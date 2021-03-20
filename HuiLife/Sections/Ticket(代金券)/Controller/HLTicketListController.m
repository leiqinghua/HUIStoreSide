//
//  HLTicketListController.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/8/5.
//

#import "HLTicketListController.h"
#import "HLTicketTableViewCell.h"
#import "HLAddTicketController.h"
#import "HLAddPromotionController.h"
#import "HLAlertController.h"
#import "HLBottomControlView.h"
#import "HLTicketMainHelper.h"
#import "HLEditPromoteController.h"

@interface HLTicketListController ()<UITableViewDelegate,UITableViewDataSource,HLTicketDelegate,HLTicketMainHelperDelegate>

@property(nonatomic,strong)UITableView * tableView;

@property(nonatomic,assign)NSInteger page;

@property(nonatomic,strong)NSMutableArray * datasource;

@property(nonatomic,strong)UIView * nodataView;

@property(nonatomic,strong)HLTicketMainHelper * mainHelper;
@end

@implementation HLTicketListController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self hl_setTitle:_ticketPromote?@"代金券推广":@"买单代金券"];
}

//添加代金券
- (void)addBtnClick {
    if (_ticketPromote) {
        HLAddPromotionController * addPromotion = [[HLAddPromotionController alloc]init];
        [self hl_pushToController:addPromotion];
        
        return;
    }
    HLAddTicketController * addVC = [[HLAddTicketController alloc]init];
    [self hl_pushToController:addVC];
}


- (void)reloadTickList:(NSNotification *)sender {
    if (self.ticketPromote) {
        _page = 1;
        [self.mainHelper loadTicketPromoteListWithPage:_page];
        return;
    }
    self.page = 1;
    [self.mainHelper loadTicketListWithPage:self.page];
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
        [HLTools shareWithId:Id type:1 controller:self completion:^(NSDictionary *dict) {
            [[SDWebImageManager sharedManager].imageDownloader downloadImageWithURL:[NSURL URLWithString:dict[@"pic"]] options:SDWebImageDownloaderUseNSURLCache progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
                dispatch_main_async_safe(^{
                    [HLWXManage shareToWXWithMiniProgramUserName:WX_MINIPAGRAM_USERNAME title:dict[@"title"] description:@"" image:image webpageUrl:dict[@"link"] path:dict[@"path"]];
                });
            }];
        }];
        return;
    }
    
    
    [HLTools shareImageWithId:Id type:1 controller:self completion:^(NSDictionary * dict) {
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
    [HLTools saveQRCodeWithId:Id type:1 controller:self completion:^(NSDictionary *data) {
        NSDictionary *pargram = @{
            @"codeImgUrl": data[@"erweimaUrl"]?:@"",
            @"navTitle": @"二维码下载",
        };
        [HLTools pushAppPageLink:@"HLMatterCodeController" params:pargram needBack:false];
    }];
}


//生成展架
/**
 type：3抢购 2卡 1券
 */
- (void)createDisplayWithId:(NSString *)Id display:(NSString *)display{
    if (!display.length) {
        [HLTools pushAppPageLink:@"HLDispalyMainController" params:@{@"pro_id":Id,@"type":@(1)} needBack:false];
    } else {
        HLShowHint(display, self.view);
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self creatFootView];
    _page = 1;
    _mainHelper = [[HLTicketMainHelper alloc]initWithDelegate:self];
    [HLNotifyCenter addObserver:self selector:@selector(reloadTickList:) name:HLReloadTicketListNotifi object:nil];
    
    if (!self.ticketPromote) {
        [self.mainHelper loadTicketListWithPage:_page];
    }else{
        [self.mainHelper loadTicketPromoteListWithPage:_page];
    }
}


// 构建底部的view
- (void)creatFootView{
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenH - FitPTScreen(91), ScreenW, FitPTScreen(91))];
    footView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:footView];
    // 加按钮
    UIButton *addBtn = [[UIButton alloc] init];
    [footView addSubview:addBtn];
    [addBtn setTitle:@"添加代金券" forState:UIControlStateNormal];
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
    _tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, FitPTScreen(15))];
    [self.view addSubview:_tableView];
    AdjustsScrollViewInsetNever(self, _tableView);
    
    [self.tableView footerWithEndText:@"没有更多信息" refreshingBlock:^{
        self.page ++;
        if (!self.ticketPromote) {
            [self.mainHelper loadTicketListWithPage:self.page];
        }else{
            [self.mainHelper loadTicketPromoteListWithPage:self.page];
        }
        
    }];
    [self.tableView hideFooter:YES];
}

#pragma mark -UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HLTicketTableViewCell * cell = [HLTicketTableViewCell dequeueReusableCell:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.ticketPromote = _ticketPromote;
    cell.model = self.datasource[indexPath.row];
    cell.mainDelegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    HLTicketModel * model = self.datasource[indexPath.row];
    return model.cellHight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HLTicketPromote * model = self.datasource[indexPath.row];
    if (_ticketPromote) {
        HLEditPromoteController * edit = [[HLEditPromoteController alloc]init];
        edit.extendId = model.extenId;
        [self hl_pushToController:edit];
        return;
    }
    
    [self shareWithModel:model];
    
}

- (void)shareWithModel:(HLTicketModel *)model{
    [HLBottomControlView showControlViewWithItemTitles:@[@"微信朋友圈",@"微信好友",@"生成展架",@"二维码下载",@"预览",model.state == 0?@"上架":@"下架",] callBack:^(HLControlType type) {
        switch (type) {
            case HLControlTypeStateUp:
            case HLControlTypeStateDown:
                [self.mainHelper upDownShelfWithTicketModel:model];
                break;
                
            case HLControlTypePreView:
                [self.mainHelper reviewWithId:model.couponId isTicket:YES];
                break;
            case HLControlTypeWXCycle://朋友圈（图片）
                [self shareWithId:model.couponId isChat:false weChat:model.wechatMoments];
                break;
            case HLControlTypeWXChat://微信好友（小程序）
                [self shareWithId:model.couponId isChat:YES weChat:model.friendCircle];
                break;
            case HLControlTypeQRCode://二维码下载）
                [self dowonLoadQRCodeWithId:model.couponId qrcode:model.qrCode];
                break;
                
            case HLControlTypeDisplay://展架）
                [self createDisplayWithId:model.couponId display:model.displayRack];
                break;
            default:
                break;
        }
    }];
}

#pragma mark -HLTicketDelegate
-(void)ticketCell:(HLTicketTableViewCell *)cell shareWithModel:(HLTicketModel *)model{
    if (_ticketPromote) {
        [self stopPromoteWithModel:model];
        return;
    }
    [self shareWithModel:model];
}

-(void)stopPromoteWithModel:(HLTicketModel*)model{
    HLAlertController * alertVC = [[HLAlertController alloc]init];
    weakify(self);
    HLAlertAction * stopAction = [[HLAlertAction alloc]initWithTitle:@"暂停推广" color:UIColorFromRGB(0xFF8E16) completion:^{
        [weak_self.mainHelper stopPromoteWithModel:model type:1];
    }];
    stopAction.showLine = false;
    [alertVC addActions:@[stopAction]];
    [self presentViewController:alertVC animated:false completion:nil];
}


#pragma mark - HLTicketMainHelperDelegate
-(void)hlEndRequestWithCode:(NSInteger)code{
    [_tableView endRefresh];
    if (code != 200 && _page>1) {
        _page -- ;
    }
}

-(void)hlLoadListDatas:(NSArray *)datas showNomalData:(BOOL)show{
    if (_page == 1) {
        [self.datasource removeAllObjects];
    }
    [self.datasource addObjectsFromArray:datas];
    if (!self.datasource.count) {
        [self showNodataView];
    }else{
        [_nodataView removeFromSuperview];
        [self.tableView hideFooter:false];
    }
    
    if (show) {
        [self.tableView endNomorData];
    }
    
    [self.tableView reloadData];
}


-(void)hlDeleteEidtModel:(id)model{
    if (self.ticketPromote) {
        HLTicketPromote * promote = (HLTicketPromote *) model;
        [self.datasource removeObject:promote];
        [self.tableView reloadData];
        if (!self.datasource.count) {
            [self showNodataView];
        }
    }
}

//更新某个model
-(void)hlReloadEditModel:(id)model{
    NSInteger index = [self.datasource indexOfObject:model];
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
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
        
        UIImageView * imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"empty_ticket_default"]];
        [_nodataView addSubview:imageV];
        [imageV makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(FitPTScreen(162));
            make.centerX.equalTo(self.nodataView);
        }];
        
        UILabel * tipLb = [[UILabel alloc]init];
        tipLb.textColor = UIColorFromRGB(0x999999);
        tipLb.font = [UIFont systemFontOfSize:FitPTScreen(15)];
        tipLb.text = @"暂无进行中代金券";
        [_nodataView addSubview:tipLb];
        [tipLb makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.nodataView);
            make.top.equalTo(imageV.bottom).offset(FitPTScreen(20));
        }];
    }
    
    [self.tableView addSubview:_nodataView];
}

@end
