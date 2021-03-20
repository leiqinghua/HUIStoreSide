//
//  HLTicketMainHelper.h
//  HuiLife
//
//  Created by 雷清华 on 2019/8/15.
//

#import <Foundation/Foundation.h>
#import "HLTicketModel.h"
#import "HLCardListModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol HLTicketMainHelperDelegate <NSObject>

@optional
//请求结束的处理
-(void)hlEndRequestWithCode:(NSInteger)code;

-(void)hlLoadListDatas:(NSArray *)datas showNomalData:(BOOL)show;
//刷新某个model
-(void)hlReloadEditModel:(id)model;
//删除某个model
-(void)hlDeleteEidtModel:(id)model;

@end


@interface HLTicketMainHelper : NSObject


-(instancetype)initWithDelegate:(id<HLTicketMainHelperDelegate>)delegate;

//请求代金券列表
-(void)loadTicketListWithPage:(NSInteger)page;

//代金券上下架
-(void)upDownShelfWithTicketModel:(HLTicketModel *)model;

-(void)upDownShelfWithCardModel:(HLCardListModel *)model;

//预览
-(void)reviewWithId:(NSString *)countId isTicket:(BOOL)ticket;

//加载卡列表
-(void)loadCardListWithPage:(NSInteger)page;

//代金券推广列表
-(void)loadTicketPromoteListWithPage:(NSInteger)page;

//暂停推广
-(void)stopPromoteWithModel:(id)model type:(NSInteger)type;

//卡推广列表
-(void)loadCardPromoteListWithPage:(NSInteger)page;

@end

NS_ASSUME_NONNULL_END
