//
//  HLPushHistoryViewController.m
//  HuiLife
//
//  Created by 王策 on 2021/4/26.
//

#import "HLPushHistoryViewController.h"
#import "HLPushHistoryModel.h"

@interface HLPushHistoryViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation HLPushHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//https://sapi.51huilife.cn/HuiLife_Api
    [self loadData];
}

- (void)loadData{
    [XMCenter sendRequest:^(XMRequest * _Nonnull request) {
        request.api = @"/push/history.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = @{@"push_id":self.push_id};
    } onSuccess:^(XMResult *  _Nullable responseObject) {
        HLHideLoading(self.view);
        if ([responseObject code] == 200) {
            //
            HLPushHistoryModel *dataModel = [HLPushHistoryModel mj_objectWithKeyValues:responseObject.data];
            [NSObject printPropertyWithDict:responseObject.data];
//            // 参数构建
//            self.mParams[KEY_IMAGE] = dataModel.image;
//            self.mParams[KEY_TITLE] = dataModel.title;
//            self.mParams[KEY_DESCRIBE] = dataModel.push_desc;
//            self.mParams[KEY_PROID] = dataModel.pro_id;
//            self.mParams[KEY_NAME] = dataModel.name;
//            self.mParams[@"push_id"] = self.pushId;
//            // UI构建
//            [self creatSubViews];
//            self.uploadState = HLPicUploadSuccess;
//            self.pushNumLab.text = [NSString stringWithFormat:@"预计%ld位HUI卡会员能接收到",[responseObject.data[@"total"] integerValue]];
//            [self.videoImgV sd_setImageWithURL:[NSURL URLWithString:dataModel.image]];
//            self.delBtn.hidden = NO;
//            self.goodNameLab.text = dataModel.name;
//            self.titleTextView.text = dataModel.title;
//            self.descTextView.text = dataModel.push_desc;
//            self.inputNumLab.text = [NSString stringWithFormat:@"%lu/50",(unsigned long)self.descTextView.text.length];
//            self.reasonLab.hidden = NO;
//            self.reasonLab.text = dataModel.reason;
//            self.reasonLab.text = @"标题与视频不符";
        }else{
            weakify(self);
            [self hl_showNetFail:self.view.bounds callBack:^{
                [weak_self loadData];
            }];
        }
    } onFailure:^(NSError * _Nullable error) {
        HLHideLoading(self.view);
        weakify(self);
        [self hl_showNetFail:self.view.bounds callBack:^{
            [weak_self loadData];
        }];
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    return cell;
}

#pragma mark - Getter

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Height_NavBar, ScreenW, ScreenH - Height_NavBar)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.separatorColor = UIColorFromRGB(0xEDEDED);
        _tableView.rowHeight = FitPTScreen(40);
        _tableView.tableFooterView = [UIView new];
//        [_tableView registerClass:[HLPushListViewCell class] forCellReuseIdentifier:@"HLPushListViewCell"];
    }
    return _tableView;
}


@end
