//
//  HLImageAlbumController.m
//  HuiLife
//
//  Created by 王策 on 2019/12/10.
//

#import "HLImageAlbumController.h"
#import "HLAlbumViewCell.h"
#import "HLImagePickerToolBar.h"
#import "HLImagePickerService.h"
#import "HLImagePreviewController.h"
#import "HLImagePickerManager.h"
#import "HLImageAssetController.h"

#define kTooBarHeight 50

@interface HLImageAlbumController () <UITableViewDelegate,UITableViewDataSource,HLImagePickerToolBarDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) HLImagePickerToolBar *toolBar;

@property (nonatomic, copy) NSArray <HLAlbum *>*dataSource;

// 记录第一次进来，第一次才有loading，之后就没有了
@property (nonatomic, assign) BOOL isFirstIn;

@end

@implementation HLImageAlbumController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isFirstIn = YES;
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.toolBar];
    AdjustsScrollViewInsetNever(self, self.tableView);
    
    // 如果是单选
    if ([HLImagePickerManager shared].config.singleSelect) {
        self.toolBar.hidden = YES;
        self.tableView.frame = CGRectMake(0, Height_NavBar, ScreenW, ScreenH - Height_NavBar - Height_Bottom_Margn);
    }
    
    self.navigationItem.title = @"相册列表";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName : UIColor.blackColor} forState:UIControlStateNormal];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // 如果此时是单选，那么就清除选中的
    if ([HLImagePickerManager shared].config.singleSelect) {
        [[HLImagePickerManager shared] clearSelectAsset];
    }
    
    // 加载
    [self loadAllAlbums];
    
    // 配置底部toolBar的选中和数量
    [self.toolBar configOrinalSelect:[HLImagePickerManager shared].config.selectOrinal];
    [self.toolBar configSelectNum:[HLImagePickerManager shared].selectAssets.count];
}

#pragma mark - Method

// 关闭页面
- (void)cancel{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

// 加载所有album
- (void)loadAllAlbums{
    if (self.isFirstIn) {
        HLLoading(self.view);
        self.isFirstIn = NO;
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [HLImagePickerService getAllImageAlbumsWithNeedFetchAssets:YES completion:^(NSArray<HLAlbum *> * albums) {
            dispatch_main_async_safe(^{
                HLHideLoading(self.view);
                self.dataSource = albums;
                for (HLAlbum *album in self.dataSource) {
                    album.selectedModels = [HLImagePickerManager shared].selectAssets;
                }
                [self.tableView reloadData];
            });
        }];
    });
}

// 预览
- (void)leftButtonClickWithToolBar:(HLImagePickerToolBar *)toolBar{
    
    NSMutableArray *selectAssets = [HLImagePickerManager shared].selectAssets;
    
    if (selectAssets.count == 0) {
        HLShowHint(@"请选取相片", self.view);
        return;
    }
    
    HLImagePreviewController *preview = [[HLImagePreviewController alloc] init];
    preview.currentIndex = 0;
    [self.navigationController pushViewController:preview animated:YES];
}

// 原图
- (void)toolBar:(HLImagePickerToolBar *)tooBar orinalSelect:(BOOL)orinalSelect{
    [HLImagePickerManager shared].config.selectOrinal = YES;
}

// 选中
- (void)selectButtonClickWithToolBar:(HLImagePickerToolBar *)toolBar{
    
    NSMutableArray *selectAssets = [HLImagePickerManager shared].selectAssets;
    
    if (selectAssets.count == 0) {
        HLShowHint(@"请选择图片", self.view);
        return;
    }
    
    HLImagePreviewController *preview = [[HLImagePreviewController alloc] init];
    preview.currentIndex = 0;
    [self.navigationController pushViewController:preview animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HLAlbumViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HLAlbumViewCell" forIndexPath:indexPath];
    cell.album = self.dataSource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HLImageAssetController *assetVC = [[HLImageAssetController alloc] init];
    assetVC.album = self.dataSource[indexPath.row];
    [self.navigationController pushViewController:assetVC animated:YES];
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Height_NavBar, ScreenW, ScreenH - Height_NavBar - kTooBarHeight)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorColor = SeparatorColor;
        _tableView.rowHeight = FitPTScreen(78);
        [_tableView registerClass:[HLAlbumViewCell class] forCellReuseIdentifier:@"HLAlbumViewCell"];
    }
    return _tableView;
}

- (HLImagePickerToolBar *)toolBar{
    if (!_toolBar) {
        _toolBar = [[HLImagePickerToolBar alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.tableView.frame), CGRectGetWidth(self.tableView.frame), kTooBarHeight) type:HLImagePickerToolBarTypePreview];
        _toolBar.delegate = self;
    }
    return _toolBar;
}

@end
