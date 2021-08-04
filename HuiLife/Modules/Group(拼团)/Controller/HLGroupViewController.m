//
//  HLGroupViewController.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/8/14.
//

#import "HLGroupViewController.h"
#import "HLGroupTableViewCell.h"
#import "HLAlertController.h"
#import "HLAddGroupController.h"
#import "HLBottomControlView.h"

@interface HLGroupViewController ()<UITableViewDelegate,UITableViewDataSource,HLGroupTableViewCellDelegate>

@property(nonatomic,strong)UITableView * tableView;

@property(nonatomic,strong)NSMutableArray * datasource;

@property(nonatomic,strong)UIView * nodataView;

@property(nonatomic,strong)HLGroupSelectModel *selectModel;

@property(nonatomic,assign)NSInteger page;

@end

@implementation HLGroupViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self hl_setTitle:_select?@"选择秒杀商品":@"拼团"];
}

//添加
-(void)addBtnClick{
    
    if (_select) {
        
        if (!_selectModel) {
            HLShowHint(@"请选择秒杀商品", self.view);
            return;
        }
        
        if (self.selectBlock) {
            self.selectBlock(_selectModel.title, _selectModel.Id,_selectModel.orgPrice);
            [self hl_goback];
        }
        
        return;
    }
    HLAddGroupController * addGroup = [[HLAddGroupController alloc]init];
    [self hl_pushToController:addGroup];
}

//刷新数据
-(void)addGroupNotifi:(NSNotification *)sender{
    _page = 1;
    [self loadGroupListWithLoading:YES];
}

//分享
-(void)shareWithId:(NSString *)Id isChat:(BOOL)isChat weChat:(NSString *)weChat{
    
    if (weChat.length) {
        HLShowHint(weChat, self.view);
        return;
    }
    
    if (![[HLPayManage shareManage].wxManage wxAppIsInstalled]) {
        HLShowText(@"请安装微信客户端");
        return;
    }
    
    if (isChat) {
        [HLTools shareWithId:Id type:6 controller:self completion:^(NSDictionary *dict) {
            [[SDWebImageManager sharedManager].imageDownloader downloadImageWithURL:[NSURL URLWithString:dict[@"pic"]] options:SDWebImageDownloaderUseNSURLCache progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
                dispatch_main_async_safe(^{
                    [HLWXManage shareToWXWithMiniProgramUserName:WX_MINIPAGRAM_USERNAME title:dict[@"title"] description:@"" image:image webpageUrl:dict[@"link"] path:dict[@"path"]];
                });
            }];
        }];
        
        return;
    }
    
    [HLTools shareImageWithId:Id type:6 controller:self completion:^(NSDictionary * dict) {
        [[SDWebImageManager sharedManager].imageDownloader downloadImageWithURL:[NSURL URLWithString:dict[@"imgUrl"]] options:SDWebImageDownloaderUseNSURLCache progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
            dispatch_main_async_safe(^{
                [HLWXManage shareToWXWithImage:image scene:HLSceneTimeline];
            });
        }];
    }];
}

//下载二维码
- (void)dowonLoadQRCodeWithId:(NSString *)Id qrcode:(NSString *)qrcode{
    if (qrcode.length) {
        HLShowHint(qrcode, self.view);
        return;
    }
    [HLTools saveQRCodeWithId:Id type:6 controller:self completion:^(NSDictionary *data) {
        NSDictionary *pargram = @{
            @"codeImgUrl": data[@"erweimaUrl"]?:@"",
              @"navTitle": @"二维码下载",
        };
        [HLTools pushAppPageLink:@"HLMatterCodeController" params:pargram needBack:false];
    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self creatFootView];
    
    _page = 1;
    [self loadGroupListWithLoading:YES];
    
    [HLNotifyCenter addObserver:self selector:@selector(addGroupNotifi:) name:HLAddGroupNotifi object:nil];
}

// 构建底部的view
- (void)creatFootView{
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenH - FitPTScreen(91), ScreenW, FitPTScreen(91))];
    footView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:footView];
    // 加按钮
    UIButton *addBtn = [[UIButton alloc] init];
    [footView addSubview:addBtn];
    [addBtn setTitle:_select?@"确定选择":@"添加拼团商品" forState:UIControlStateNormal];
    addBtn.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(15)];
    [addBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [addBtn setBackgroundImage:[UIImage imageNamed:@"voucher_bottom_btn"] forState:UIControlStateNormal];
    [addBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(FitPTScreen(0));
        make.width.equalTo(FitPTScreen(307));
        make.height.equalTo(FitPTScreen(72));
    }];
    [addBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

-(void)initView{
    self.view.backgroundColor = UIColor.whiteColor;
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, Height_NavBar, ScreenW, ScreenH - Height_NavBar - FitPTScreen(118)) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = UIColor.whiteColor;
    _tableView.rowHeight = FitPTScreen(135);
    [self.view addSubview:_tableView];
    AdjustsScrollViewInsetNever(self, _tableView);
    
    [_tableView hideFooter:YES];
    [_tableView footerWithEndText:@"没有更多数据" refreshingBlock:^{
        self.page ++;
        [self loadGroupListWithLoading:false];
    }];
    [_tableView hideFooter:YES];
}

#pragma mark -UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datasource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HLGroupTableViewCell * cell = [HLGroupTableViewCell dequeueReusableCell:tableView];
    cell.select = _select;
    cell.groupModel = self.datasource[indexPath.row];
    cell.delegate = self;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HLGroupModel * model = self.datasource[indexPath.row];
    if (_select) {
        HLGroupSelectModel * selectModel = (HLGroupSelectModel * )model;
        if (![_selectModel isEqual:selectModel])_selectModel.clicked = false;
        selectModel.clicked = YES;
        _selectModel = selectModel;
        [tableView reloadData];
        return;
    }
    [self shareWithModel:self.datasource[indexPath.row]];
}

#pragma mark - HLGroupTableViewCellDelegate
-(void)listViewCell:(HLGroupTableViewCell *)cell moreBtnClick:(HLGroupModel *)goodModel{
    [self shareWithModel:goodModel];
}

- (void)shareWithModel:(HLGroupModel *)model{
    [HLBottomControlView showControlViewWithItemTitles:@[@"微信朋友圈",@"微信好友",@"二维码下载",model.upState == 0?@"上架":@"下架",] callBack:^(HLControlType type) {
        switch (type) {
            case HLControlTypeStateUp:
            case HLControlTypeStateDown:
                [self upStateWithState:model.upState groupModel:model];
                break;
            case HLControlTypeWXCycle://朋友圈（图片）
                [self shareWithId:model.proId isChat:false weChat:model.wechatMoments];
                break;
            case HLControlTypeWXChat://微信好友（小程序）
                [self shareWithId:model.proId isChat:YES weChat:model.goodFriend];
                break;
            case HLControlTypeQRCode://二维码下载）
                [self dowonLoadQRCodeWithId:model.proId qrcode:model.qrCode];
                break;
            default:
                break;
        }
    }];
}

#pragma mark - function
-(void)upStateWithState:(NSInteger)state groupModel:(HLGroupModel *)model{
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/MerchantSideA/GroupBuy.php?action=3";
        request.serverType = HLServerTypeNormal;
        request.parameters = @{@"state":@(state),@"grpBuyId":model.Id,@"proId":model.proId};
    }onSuccess:^(id responseObject) {
        HLHideLoading(self.view);
        // 处理数据
        XMResult *result = (XMResult *)responseObject;
        if (result.code == 200) {
            HLShowHint(state == 0?@"上架成功":@"下架成功", self.view);
            //改状态
            [model mj_setKeyValues:result.data];
            NSInteger index = [self.datasource indexOfObject:model];
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }
    }onFailure:^(NSError *error) {
        HLHideLoading(self.view);
    }];
}

#pragma mark -
-(void)loadGroupListWithLoading:(BOOL)loading{
    if (loading) HLLoading(self.view);
    NSString * api = _select?@"/MerchantSide/HotSeckillListGB.php":@"/MerchantSideA/GroupBuy.php?action=1";
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = api;
        request.serverType = HLServerTypeNormal;
        request.parameters = @{@"page":@(self.page)};
    }onSuccess:^(id responseObject) {
        HLHideLoading(self.view);
        [self.tableView endRefresh];
        // 处理数据
        XMResult *result = (XMResult *)responseObject;
        if (result.code == 200) {
            [self handleDataWithList:result.data[@"items"]];
        }
    }onFailure:^(NSError *error) {
        HLHideLoading(self.view);
        [self.tableView endRefresh];
    }];
}

-(void)handleDataWithList:(NSArray *)list{
    
    if (_page == 1) {
        [self.datasource removeAllObjects];
    }
    if (!_select) {
        NSArray * datas = [HLGroupModel mj_objectArrayWithKeyValuesArray:list];
        [self.datasource addObjectsFromArray:datas];
    }else{
        NSArray * datas = [HLGroupSelectModel mj_objectArrayWithKeyValuesArray:list];
        [self.datasource addObjectsFromArray:datas];
    }
    
    if (self.datasource.count) {
        [_nodataView removeFromSuperview];
        [_tableView hideFooter:false];
    }else{
        [self showNodataView];
        [_tableView hideFooter:YES];
    }
    
    if (list.count == 0) {
        [_tableView endNomorData];
    }
    
    [self.tableView reloadData];
    
}


-(NSMutableArray *)datasource{
    if (!_datasource) {
        _datasource = [NSMutableArray array];
    }
    return _datasource;
}


-(void)showNodataView{
    if (!_nodataView) {
        _nodataView = [[UIView alloc]initWithFrame:self.tableView.bounds];
        _nodataView.backgroundColor = UIColor.whiteColor;
        
        UIImageView * imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"empty_group_default"]];
        [_nodataView addSubview:imageV];
        [imageV makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(FitPTScreen(162));
            make.centerX.equalTo(self.nodataView);
        }];
        
        UILabel * tipLb = [[UILabel alloc]init];
        tipLb.textColor = UIColorFromRGB(0x999999);
        tipLb.font = [UIFont systemFontOfSize:FitPTScreen(15)];
        tipLb.text = @"暂无进行中拼团商品";
        [_nodataView addSubview:tipLb];
        [tipLb makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.nodataView);
            make.top.equalTo(imageV.bottom).offset(FitPTScreen(20));
        }];
    }
    [self.tableView addSubview:_nodataView];
}


@end
