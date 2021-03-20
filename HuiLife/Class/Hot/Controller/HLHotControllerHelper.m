//
//  HLHotControllerHelper.m
//  HuiLife
//
//  Created by 雷清华 on 2020/3/19.
//

#import "HLHotControllerHelper.h"
#import "HLHotListModel.h"
#import "HLHotToast.h"

@implementation HLHotControllerHelper

- (instancetype)initWithDelegate:(id<HLHotControllerDelegate>)delegate {
    if (self = [super init]) {
        _delegate = delegate;
    }
    return self;
}

//请求大类
- (void)hl_mainRequestBigClassWithLoading:(void(^)(BOOL))loadCallBack {
    loadCallBack(YES);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/MerchantSideA/HotSellsClassList.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = @{};
    } onSuccess:^(id responseObject) {
        loadCallBack(NO);
        // 处理数据
        XMResult * result = (XMResult *)responseObject;
        NSArray *bigClasses;
        if (result.code == 200) {
            NSArray *bigArr = result.data[@"huiClassList"];
            bigClasses = [HLHotClass mj_objectArrayWithKeyValuesArray:bigArr];
        }
        if ([self.delegate respondsToSelector:@selector(hl_mainRequestResultWithBigClasses:)]) {
            [self.delegate hl_mainRequestResultWithBigClasses:bigClasses];
        }
        
    } onFailure:^(NSError *error) {
        loadCallBack(NO);
        if ([self.delegate respondsToSelector:@selector(hl_mainRequestResultWithBigClasses:)]) {
            [self.delegate hl_mainRequestResultWithBigClasses:nil];
        }
    }];
}

//请求小类
- (void)hl_mainRequestSubClassWithBigId:(NSString *)bigId loading:(void(^)(BOOL))loadCallBack {
    loadCallBack(YES);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/MerchantSideA/HotSellsClassList.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = @{@"big_id":bigId};
    } onSuccess:^(id responseObject) {
        loadCallBack(NO);
        // 处理数据
        XMResult * result = (XMResult *)responseObject;
        if (result.code == 200) {
            NSArray *subArr = result.data[@"huiSubClassList"];
            NSArray *subClasses = [HLHotClass mj_objectArrayWithKeyValuesArray:subArr];
            if ([self.delegate respondsToSelector:@selector(hl_mainRequestResultWithSubClasses:)]) {
                [self.delegate hl_mainRequestResultWithSubClasses:subClasses];
            }
        }
        
    } onFailure:^(NSError *error) {
        loadCallBack(NO);
    }];
}

//请求列表
- (void)hl_mainRequestListWithBigId:(NSString *)bigId subId:(NSString *)subId page:(NSInteger)page loading:(void(^)(BOOL))loadCallBack {
    loadCallBack(YES);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/MerchantSideA/HotSellsList.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = @{@"big_id":bigId,@"sub_id":subId,@"page":@(page)};
    } onSuccess:^(id responseObject) {
        loadCallBack(NO);
        // 处理数据
        XMResult * result = (XMResult *)responseObject;
        if (result.code == 200) {
            NSArray *listArr = result.data[@"list"];
            BOOL isMore = [result.data[@"isMore"] boolValue];
            NSArray *lists = [HLHotListModel mj_objectArrayWithKeyValuesArray:listArr];
            if ([self.delegate respondsToSelector:@selector(hl_mainList:page:noMore:)]) {
                [self.delegate hl_mainList:lists page:page noMore:isMore];
            }
            return;
        }
        NSInteger curPage = page;
        if (curPage > 1) {
            curPage -= 1;
        }
        if ([self.delegate respondsToSelector:@selector(hl_mainList:page:noMore:)]) {
            [self.delegate hl_mainList:@[] page:curPage noMore:NO];
        }
        
    } onFailure:^(NSError *error) {
        loadCallBack(NO);
        NSInteger curPage = page;
        if (curPage > 1) {
            curPage -= 1;
        }
        if ([self.delegate respondsToSelector:@selector(hl_mainList:page:noMore:)]) {
            [self.delegate hl_mainList:@[] page:curPage noMore:NO];
        }
    }];
}

//请求吐司
- (void)hl_requestToastWithResult:(void(^)(NSArray *))callBack {
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/MerchantSideA/HotSellsToast.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = @{};
    } onSuccess:^(id responseObject) {
        // 处理数据
        XMResult * result = (XMResult *)responseObject;
        if (result.code == 200) {
            NSArray *info = result.data[@"info"];
            NSArray *toasts = [HLHotToastModel mj_objectArrayWithKeyValuesArray:info];
            if (callBack) {
                callBack(toasts);
            }
        }
    } onFailure:^(NSError *error) {
    
    }];
}

@end
