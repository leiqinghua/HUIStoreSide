//
//  HLExportRecordController.m
//  HuiLife
//
//  Created by 雷清华 on 2020/9/8.
//

#import "HLExportRecordController.h"
#import "HLCustomerInfo.h"
#import "HLExportRecordCell.h"

@interface HLExportRecordController () <UITableViewDelegate, UITableViewDataSource, HLExportRecordCellDelegate, UIDocumentInteractionControllerDelegate>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, assign) NSInteger page;
@property(nonatomic, strong) NSMutableArray *datasource;
@property(nonatomic, strong) UIView *noDataView;//缺省图
@end

@implementation HLExportRecordController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self hl_setTitle:@"导出记录"];
    [self hl_setBackImage:@"back_oriange"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _page = 1;
    [self loadListWithHud:YES];
}

#pragma mark - Request
- (void)loadListWithHud:(BOOL)hud {
    if (hud) HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/CardBag/mybag/CustomerExportList.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = @{@"userIdBuss":[HLAccount shared].userIdBuss?:@"",@"pageNo":@(_page)};
    } onSuccess:^(id responseObject) {
        HLHideLoading(self.view);
        [self.tableView endRefresh];
        XMResult *result = (XMResult *)responseObject;
        if (result.code == 200) {
            [self initSubView];
            [self handleDatas:result.data[@"active"]];
            return;
        }
        if (_page > 1) _page--;
    }onFailure:^(NSError *error) {
        HLHideLoading(self.view);
        if (_page > 1) _page--;
    }];
}

- (void)handleDatas:(NSArray *)datas {
    NSArray *list = [HLExportRecordInfo mj_objectArrayWithKeyValuesArray:datas];
    if (_page == 1) [self.datasource removeAllObjects];
    [self.datasource addObjectsFromArray:list];
    [self.tableView hideFooter:!self.datasource.count];
    if (!list.count) [self.tableView endNomorData];
    [self.tableView reloadData];
    
    [self showNodataView:!self.datasource.count];
}

#pragma mark - Method
- (void)showNodataView:(BOOL)show {
    if (show && !_noDataView) {
        _noDataView = [[UIView alloc]initWithFrame:CGRectMake(FitPTScreen(127), FitPTScreen(150), FitPTScreen(133), FitPTScreen(150))];
        [self.tableView addSubview:_noDataView];
        
        UIImageView *tipImV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"empty_cus_default"]];
        [_noDataView addSubview:tipImV];
        [tipImV makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(FitPTScreen(10));
            make.centerX.equalTo(self.noDataView);
        }];
        
        UILabel *tipLb = [UILabel hl_regularWithColor:@"#AAAAAA" font:12];
        tipLb.text = @"暂无导出记录";
        [_noDataView addSubview:tipLb];
        [tipLb makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(tipImV.bottom).offset(FitPTScreen(21));
            make.centerX.equalTo(self.noDataView);
        }];
    }
    
    _noDataView.hidden = !show;
}

#pragma mark - HLExportRecordCellDelegate
//点击下载
- (void)recordCell:(HLExportRecordCell *)cell index:(NSInteger)index {
    HLExportRecordInfo *info = self.datasource[index];
    if (!info.fileName.length) return;
    if (!info.done) { //下载
        //文件夹 kcusExportDir
        NSString *dirPath = [HLFileManager pathWithDir:kcusExportDir];
        if (!dirPath.length) return;
        //文件目录
        NSString *filePath = [dirPath stringByAppendingPathComponent:info.fileUrl.lastPathComponent];
        HLLoading(self.view);
        [XMCenter sendRequest:^(XMRequest * _Nonnull request) {
            request.url = info.fileUrl;
            request.requestType = kXMRequestDownload;
            request.downloadSavePath = filePath;
        } onProgress:^(NSProgress * _Nonnull progress) {
            HLLog(@"progress = %@",progress);
        } onSuccess:^(id  _Nullable responseObject) {
            HLHideLoading(self.view);
            HLLog(@"responseObject = %@",responseObject);
            info.filePath = filePath;
            [self.tableView reloadRowsAtIndexPaths:@[[self.tableView indexPathForCell:cell]] withRowAnimation:UITableViewRowAnimationNone];
        } onFailure:^(NSError * _Nullable error) {
            HLHideLoading(self.view);
        }];
        return;
    }
    //直接打开预览
    UIDocumentInteractionController *documentController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:info.filePath]];
    documentController.delegate = self;
    [documentController presentPreviewAnimated:NO];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HLExportRecordCell *cell = (HLExportRecordCell *)[tableView hl_dequeueReusableCellWithIdentifier:@"HLExportRecordCell" indexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSInteger row = ((indexPath.row + 1) % 2);
    if (row == 0) [cell configBackgroundColor:@"#FAFAFA"];
    else [cell configBackgroundColor:@"#FFFFFF"];
    HLExportRecordInfo *info = self.datasource[indexPath.row];
    [cell configNum:info.sum name:info.fileName time:info.exportTime done:info.done];
    cell.delegate = self;
    cell.index = indexPath.row;
    return cell;
}

#pragma mark - UIDocumentInteractionControllerDelegate
- (UIViewController*)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController*)controller
{
    return self;
}

- (UIView*)documentInteractionControllerViewForPreview:(UIDocumentInteractionController*)controller
{
    return self.view;
}

- (CGRect)documentInteractionControllerRectForPreview:(UIDocumentInteractionController*)controller
{
    return self.view.frame;
}
#pragma mark - UIView
- (void)initSubView {
    if (_tableView) return;
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, Height_NavBar, ScreenW, ScreenH - Height_NavBar)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    _tableView.rowHeight = FitPTScreen(45);
    _tableView.scrollsToTop = YES;
    [self.view addSubview:_tableView];
    AdjustsScrollViewInsetNever(self, _tableView);
    
    UIView *tableHead = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, FitPTScreen(52))];
    tableHead.backgroundColor = UIColor.whiteColor;
    _tableView.tableHeaderView = tableHead;
    
    UILabel *numLb = [UILabel hl_regularWithColor:@"#9A9A9A" font:12];
    numLb.text = @"导出数量";
    [tableHead addSubview:numLb];
    [numLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(22));
        make.top.equalTo(FitPTScreen(29));
    }];
    
    UILabel *nameLb = [UILabel hl_regularWithColor:@"#9A9A9A" font:12];
    nameLb.text = @"文件名";
    [tableHead addSubview:nameLb];
    [nameLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(numLb.right).offset(FitPTScreen(7));
        make.top.equalTo(FitPTScreen(29));
    }];
    
    UILabel *timeLb = [UILabel hl_regularWithColor:@"#9A9A9A" font:12];
    timeLb.text = @"导出时间";
    [tableHead addSubview:timeLb];
    [timeLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLb.right).offset(FitPTScreen(77));
        make.top.equalTo(FitPTScreen(29));
    }];
    
    UILabel *downLb = [UILabel hl_regularWithColor:@"#9A9A9A" font:12];
    downLb.text = @"下载";
    [tableHead addSubview:downLb];
    [downLb makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-34));
        make.top.equalTo(FitPTScreen(29));
    }];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = UIColorFromRGB(0xE9E9E9);
    [tableHead addSubview:line];
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(12));
        make.right.equalTo(FitPTScreen(-12));
        make.bottom.equalTo(FitPTScreen(-1));
        make.height.equalTo(FitPTScreen(0.5));
    }];
    
    [_tableView footerWithEndText:@"暂无更多数据" refreshingBlock:^{
        self.page += 1;
        [self loadListWithHud:NO];
    }];
    [_tableView hideFooter:YES];
}

#pragma mark - getter
- (NSMutableArray *)datasource {
    if (!_datasource) {
        _datasource = [NSMutableArray array];
    }
    return _datasource;
}

@end

