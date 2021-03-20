//
//  HLCarMarketController.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/8/8.
//

#import "HLCarMarketController.h"
#import "HLCarMarketViewCell.h"
#import "HLAddCardController.h"
#import "HLAddPromotionController.h"
#import "HLAlertController.h"
#import "HLTicketMainHelper.h"
#import "HLBottomControlView.h"
#import "HLEditPromoteController.h"

@interface HLCarMarketController ()<UITableViewDelegate,UITableViewDataSource, HLCardMarketDelegate ,HLTicketMainHelperDelegate>

@property(nonatomic,strong)UIView * nodataView;

@property(nonatomic,strong)UITableView * tableView;

@property(nonatomic,strong)NSMutableArray * datasource;

@property(nonatomic,strong)HLTicketMainHelper * mainHelper;

@property(nonatomic,assign)NSInteger page;

@end

@implementation HLCarMarketController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self hl_setTitle:@"卡推广"];
}

//添加卡
-(void)addClick{
    if (_isPromote) {
        HLAddPromotionController * addPromote = [[HLAddPromotionController alloc]init];
        addPromote.cardPromote = YES;
        [self hl_pushToController:addPromote];
        return;
    }
    
    HLAddCardController * addCard = [[HLAddCardController alloc]init];
    addCard.type = _type;
    [self hl_pushToController:addCard];
}


-(void)reloadList:(NSNotification *)sender{
    self.page = 1;
    if (!_isPromote) {
        [self.mainHelper loadCardListWithPage:self.page];
    }else{
        [self.mainHelper loadCardPromoteListWithPage:self.page];
    }
    
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
        [HLTools shareWithId:Id type:2 controller:self completion:^(NSDictionary *dict) {
            [[SDWebImageManager sharedManager].imageDownloader downloadImageWithURL:[NSURL URLWithString:dict[@"pic"]] options:SDWebImageDownloaderUseNSURLCache progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
                dispatch_main_async_safe(^{
                    [HLWXManage shareToWXWithMiniProgramUserName:WX_MINIPAGRAM_USERNAME title:dict[@"title"] description:@"" image:image webpageUrl:dict[@"link"] path:dict[@"path"]];
                });
            }];
        }];
        return;
    }
    
    [HLTools shareImageWithId:Id type:2 controller:self completion:^(NSDictionary * dict) {
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
    
    [HLTools saveQRCodeWithId:Id type:2 controller:self completion:^(NSDictionary *data) {
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
           [HLTools pushAppPageLink:@"HLDispalyMainController" params:@{@"pro_id":Id,@"type":@(2)} needBack:false];
       } else {
           HLShowHint(display, self.view);
       }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    [self creatFootView];
    [self.view addSubview:self.tableView];
    
    _page = 1;
    _mainHelper = [[HLTicketMainHelper alloc]initWithDelegate:self];
    
    if (!_isPromote) {
        [_mainHelper loadCardListWithPage:_page];
    }else{
        [self.mainHelper loadCardPromoteListWithPage:self.page];
    }
    
    
    [self.tableView footerWithEndText:@"没有更多信息" refreshingBlock:^{
        self.page ++;
        if (!self.isPromote) {
           [self.mainHelper loadCardListWithPage:self.page];
        }else{
            [self.mainHelper loadCardPromoteListWithPage:self.page];
        }
        
    }];
    [self.tableView hideFooter:YES];
    
    [HLNotifyCenter addObserver:self selector:@selector(reloadList:) name:HLReloadCardListNotifi object:nil];
}

// 构建底部的view
- (void)creatFootView{
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenH - FitPTScreen(91), ScreenW, FitPTScreen(91))];
    footView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:footView];
    // 加按钮
    UIButton *saveButton = [[UIButton alloc] init];
    [footView addSubview:saveButton];
    [saveButton setTitle:@"添加卡" forState:UIControlStateNormal];
    saveButton.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(15)];
    [saveButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [saveButton setBackgroundImage:[UIImage imageNamed:@"voucher_bottom_btn"] forState:UIControlStateNormal];
    [saveButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(FitPTScreen(0));
        make.width.equalTo(FitPTScreen(307));
        make.height.equalTo(FitPTScreen(72));
    }];
    [saveButton addTarget:self action:@selector(addClick) forControlEvents:UIControlEventTouchUpInside];
}


#pragma mark -UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datasource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HLCarMarketViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"HLCarMarketViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.isPromote = _isPromote;
    cell.delegate = self;
    cell.baseModel = self.datasource[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!_isPromote) {
        HLCardPromote * model = self.datasource[indexPath.row];
        [self shareWithListModel:model];
        return;
    }
    
    HLCardPromote * model = self.datasource[indexPath.row];
    HLEditPromoteController * editPromote = [[HLEditPromoteController alloc]init];
    editPromote.cardEdit = YES;
    editPromote.extendId = model.extenId;
    [self hl_pushToController:editPromote];
}


-(void)shareWithListModel:(HLCardListModel *)model{
    [HLBottomControlView showControlViewWithItemTitles:@[@"微信朋友圈",@"微信好友",@"生成展架",@"二维码下载",@"预览",model.state == 0?@"上架":@"下架",] callBack:^(HLControlType type) {
        switch (type) {
            case HLControlTypeStateUp:
            case HLControlTypeStateDown:
                [self.mainHelper upDownShelfWithCardModel:model];
                break;
            case HLControlTypePreView:
                [self.mainHelper reviewWithId:model.cardId isTicket:false];
                break;
            case HLControlTypeWXCycle://朋友圈（图片）
                [self shareWithId:model.cardId isChat:false weChat:model.wechatMoments];
                break;
            case HLControlTypeWXChat://微信好友（小程序）
                [self shareWithId:model.cardId isChat:YES weChat:model.friendCircle];
                break;
            case HLControlTypeQRCode://二维码下载
                [self dowonLoadQRCodeWithId:model.cardId qrcode:model.qrCode];
                break;
            case HLControlTypeDisplay://生成展架
                [self createDisplayWithId:model.cardId display:model.displayRack];
                break;
            default:
                break;
        }
    }];
}

#pragma mark - HLCardMarketDelegate
-(void)cardMarkcetCell:(HLCarMarketViewCell *)cell shareWithModel:(HLCardListModel *)model{
    if (_isPromote) {
        [self stopPromoteWithModel:model];
        return;
    }
    [self shareWithListModel:model];
}


-(void)stopPromoteWithModel:(HLCardListModel*)model{
    HLAlertController * alertVC = [[HLAlertController alloc]init];
    weakify(self);
    HLAlertAction * stopAction = [[HLAlertAction alloc]initWithTitle:@"暂停推广" color:UIColorFromRGB(0xFF8E16) completion:^{
        [weak_self.mainHelper stopPromoteWithModel:model type:2];
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
        if (show) {
            [self.tableView endNomorData];
        }
    }
    [self.tableView reloadData];
}


-(void)hlDeleteEidtModel:(id)model{
    if (_isPromote) {
        HLCardPromote * promote = (HLCardPromote *) model;
        [self.datasource removeObject:promote];
        [self.tableView reloadData];
        if (!self.datasource.count) {
            [self showNodataView];
        }
    }
}

-(void)hlReloadEditModel:(id)model{
    NSInteger index = [self.datasource indexOfObject:model];
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Height_NavBar, ScreenW, ScreenH - Height_NavBar - FitPTScreen(118))];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = FitPTScreen(191);
        _tableView.separatorColor = SeparatorColor;
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerClass:[HLCarMarketViewCell class] forCellReuseIdentifier:@"HLCarMarketViewCell"];
        _tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, FitPTScreen(15))];
    }
    return _tableView;
}

- (NSMutableArray *)datasource{
    if (!_datasource) {
        _datasource = [NSMutableArray array];
    }
    return _datasource;
}


-(void)showNodataView{
    if (!_nodataView) {
        _nodataView = [[UIView alloc]initWithFrame:self.tableView.bounds];
        _nodataView.backgroundColor = UIColor.whiteColor;
        
        UIImageView * imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"empty_card_default"]];
        [_nodataView addSubview:imageV];
        [imageV makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(FitPTScreen(162));
            make.centerX.equalTo(self.nodataView);
        }];
        
        UILabel * tipLb = [[UILabel alloc]init];
        tipLb.textColor = UIColorFromRGB(0x999999);
        tipLb.font = [UIFont systemFontOfSize:FitPTScreen(15)];
        tipLb.text = @"暂无进行中卡";
        [_nodataView addSubview:tipLb];
        [tipLb makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.nodataView);
            make.top.equalTo(imageV.bottom).offset(FitPTScreen(20));
        }];
    }
    
    [self.tableView addSubview:_nodataView];
}



@end
