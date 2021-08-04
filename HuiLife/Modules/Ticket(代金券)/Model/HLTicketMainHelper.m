//
//  HLTicketMainHelper.m
//  HuiLife
//
//  Created by 雷清华 on 2019/8/15.
//

#import "HLTicketMainHelper.h"
#import "HLProduceReviewController.h"
#import "HLCarMarketController.h"

@interface HLTicketMainHelper ()

@property(nonatomic,weak)id<HLTicketMainHelperDelegate>delegate;

@end

@implementation HLTicketMainHelper

-(void)endRequestWithCode:(NSInteger)code{
    if ([self.delegate respondsToSelector:@selector(hlEndRequestWithCode:)]) {
        [self.delegate hlEndRequestWithCode:code];
    }
}


-(instancetype)initWithDelegate:(id<HLTicketMainHelperDelegate>)delegate {
    if (self = [super init]) {
        _delegate = delegate;
    }
    return self;
}

#pragma mark -代金券列表

-(void)loadTicketListWithPage:(NSInteger)page{
    
    HLBaseViewController * basevc = (HLBaseViewController *)_delegate;
    HLLoading(basevc.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/Shopplus/Couponmanager/getCouponList";
        request.serverType = HLServerTypeStoreService;
        request.parameters = @{@"page":@(page)};
    } onSuccess:^(id responseObject) {
        HLHideLoading(basevc.view);
        // 处理数据
        XMResult * result = (XMResult *)responseObject;
        [self endRequestWithCode:result.code];
        if(result.code == 200){
            [self handleListDataWithData:result.data page:page];
        }
    } onFailure:^(NSError *error) {
        HLHideLoading(basevc.view);
        [self endRequestWithCode:10000];
    }];
}

-(void)handleListDataWithData:(NSDictionary *)dict page:(NSInteger)page{
    
    NSArray * datas = [HLTicketModel mj_objectArrayWithKeyValuesArray:dict[@"couponDatas"]];
    NSInteger countPage = [dict[@"countPage"] integerValue];
    if ([self.delegate respondsToSelector:@selector(hlLoadListDatas:showNomalData:)]) {
        [self.delegate hlLoadListDatas:datas showNomalData:page >= countPage];
    }

}


#pragma mark -卡列表

-(void)loadCardListWithPage:(NSInteger)page{
    HLCarMarketController * basevc = (HLCarMarketController *)_delegate;
    
    HLLoading(basevc.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/Shopplus/Cardmarket/getCardList";
        request.serverType = HLServerTypeStoreService;
        request.parameters = @{@"page":@(page),@"type":@(basevc.type)};
    } onSuccess:^(id responseObject) {
        HLHideLoading(basevc.view);
        // 处理数据
        XMResult * result = (XMResult *)responseObject;
        [self endRequestWithCode:result.code];
        if(result.code == 200){
            [self handleCardListDataWithData:result.data page:page];
        }
    } onFailure:^(NSError *error) {
        HLHideLoading(basevc.view);
        [self endRequestWithCode:10000];
    }];
}

-(void)handleCardListDataWithData:(NSDictionary *)dict page:(NSInteger)page{
    NSArray * datas = [HLCardListModel mj_objectArrayWithKeyValuesArray:dict[@"cardDatas"]];
    NSInteger countPage = [dict[@"cardPage"] integerValue];
    if ([self.delegate respondsToSelector:@selector(hlLoadListDatas:showNomalData:)]) {
        [self.delegate hlLoadListDatas:datas showNomalData:page >= countPage];
    }
}


#pragma mark -代金券推广列表
-(void)loadTicketPromoteListWithPage:(NSInteger)page{
    HLBaseViewController * basevc = (HLBaseViewController *)_delegate;
    HLLoading(basevc.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/Shopplus/Extencoupon/getExtenList";
        request.serverType = HLServerTypeStoreService;
        request.parameters = @{@"page":@(page)};
    } onSuccess:^(id responseObject) {
        HLHideLoading(basevc.view);
        // 处理数据
        XMResult * result = (XMResult *)responseObject;
        [self endRequestWithCode:result.code];
        if(result.code == 200){
            [self handleTicketPromoteDataWithData:result.data page:page];
        }
    } onFailure:^(NSError *error) {
        HLHideLoading(basevc.view);
        [self endRequestWithCode:10000];
    }];
}

-(void)handleTicketPromoteDataWithData:(NSDictionary *)dict page:(NSInteger)page{
    NSArray * datas = [HLTicketPromote mj_objectArrayWithKeyValuesArray:dict[@"extenDatas"]];
    NSInteger countPage = [dict[@"cardPage"] integerValue];
    if ([self.delegate respondsToSelector:@selector(hlLoadListDatas:showNomalData:)]) {
        [self.delegate hlLoadListDatas:datas showNomalData:page >= countPage];
    }
}

#pragma mark - 卡推广列表
-(void)loadCardPromoteListWithPage:(NSInteger)page{
    HLBaseViewController * basevc = (HLBaseViewController *)_delegate;
    HLLoading(basevc.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/Shopplus/Extencard/getExtenList";
        request.serverType = HLServerTypeStoreService;
        request.parameters = @{@"page":@(page)};
    } onSuccess:^(id responseObject) {
        HLHideLoading(basevc.view);
        // 处理数据
        XMResult * result = (XMResult *)responseObject;
        [self endRequestWithCode:result.code];
        if(result.code == 200){
            [self handleCardPromoteDataWithData:result.data page:page];
        }
    } onFailure:^(NSError *error) {
        HLHideLoading(basevc.view);
        [self endRequestWithCode:10000];
    }];
}

-(void)handleCardPromoteDataWithData:(NSDictionary *)dict page:(NSInteger)page{
    NSArray * datas = [HLCardPromote mj_objectArrayWithKeyValuesArray:dict[@"extenDatas"]];
    NSInteger countPage = [dict[@"countPage"] integerValue];
    if ([self.delegate respondsToSelector:@selector(hlLoadListDatas:showNomalData:)]) {
        [self.delegate hlLoadListDatas:datas showNomalData:page >= countPage];
    }
}


#pragma mark -代金券上下架

-(void)upDownShelfWithTicketModel:(HLTicketModel *)model{
    HLBaseViewController * basevc = (HLBaseViewController *)_delegate;
    HLLoading(basevc.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/Shopplus/Couponmanager/lowerShelf";
        request.serverType = HLServerTypeStoreService;
        request.parameters = @{@"couonId":model.couponId,@"status":@(model.state)};
    } onSuccess:^(id responseObject) {
        HLHideLoading(basevc.view);
        XMResult * result = (XMResult *)responseObject;
        if (result.code == 200) {
            HLShowHint(model.state ==0?@"上架成功":@"下架成功", basevc.view);
            model.state = (1-model.state);
            [model mj_setKeyValues:result.data];
            if ([self.delegate respondsToSelector:@selector(hlReloadEditModel:)]) {
                [self.delegate hlReloadEditModel:model];
            }
        }
        
    } onFailure:^(NSError *error) {
        HLHideLoading(basevc.view);
    }];
}

#pragma mark - 卡上下架
-(void)upDownShelfWithCardModel:(HLCardListModel *)model{
    HLBaseViewController * basevc = (HLBaseViewController *)_delegate;
    HLLoading(basevc.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/Shopplus/Cardmarket/lowerShelf";
        request.serverType = HLServerTypeStoreService;
        request.parameters = @{@"cardId":model.cardId,@"status":@(model.state)};
    } onSuccess:^(id responseObject) {
        HLHideLoading(basevc.view);
        XMResult * result = (XMResult *)responseObject;
        if (result.code == 200) {
            HLShowHint(model.state ==0?@"上架成功":@"下架成功", basevc.view);
            model.state = (1-model.state);
            [model mj_setKeyValues:result.data];
            if ([self.delegate respondsToSelector:@selector(hlReloadEditModel:)]) {
                [self.delegate hlReloadEditModel:model];
            }
        }
        
    } onFailure:^(NSError *error) {
        HLHideLoading(basevc.view);
    }];
}


#pragma mark -预览

-(void)reviewWithId:(NSString *)countId isTicket:(BOOL)ticket{
    
    HLBaseViewController * basevc = (HLBaseViewController *)_delegate;
    HLLoading(basevc.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = ticket?@"/Shopplus/Couponmanager/getJumpUrl":@"/Shopplus/Cardmarket/getCardUrl";
        request.serverType = HLServerTypeStoreService;
        request.parameters = @{(ticket?@"couonId":@"cardId"):countId};
    } onSuccess:^(id responseObject) {
        HLHideLoading(basevc.view);
        XMResult * result = (XMResult *)responseObject;
        
        if (result.code == 200) {
            NSString * url = result.data[@"url"];
            HLProduceReviewController * productReview = [[HLProduceReviewController alloc]init];
            [productReview resetWebViewFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
            productReview.loadUrl = url;
            productReview.isTicket = ticket;
            [basevc hl_pushToController:productReview];
        }
        
    } onFailure:^(NSError *error) {
        HLHideLoading(basevc.view);
    }];
}

#pragma mark - 暂停推广
-(void)stopPromoteWithModel:(id)model type:(NSInteger)type{
    HLTicketPromote * promote;
    HLCardPromote * carPromote;
    if (type == 1) {
        promote = (HLTicketPromote *)model;
    }else{
        carPromote = (HLCardPromote *)model;
    }
    
    NSDictionary * pargram = @{
                               @"extenId":type==1?promote.extenId:carPromote.extenId,
                               @"isExten":type==1?@(promote.isExten):@(carPromote.isExten),
                               @"type":@(type)
                               };
    
    HLBaseViewController * basevc = (HLBaseViewController *)_delegate;
    HLLoading(basevc.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/Shopplus/Extencoupon/changeExtenStatus";
        request.serverType = HLServerTypeStoreService;
        request.parameters = pargram;
    } onSuccess:^(id responseObject) {
        HLHideLoading(basevc.view);
        XMResult * result = (XMResult *)responseObject;
        if (result.code == 200) {
            if ([self.delegate respondsToSelector:@selector(hlDeleteEidtModel:)]) {
                [self.delegate hlDeleteEidtModel:model];
            }
        }
        
    } onFailure:^(NSError *error) {
        HLHideLoading(basevc.view);
    }];
}

@end
