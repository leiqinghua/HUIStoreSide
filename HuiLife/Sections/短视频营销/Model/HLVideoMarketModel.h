//
//  HLVideoMarketModel.h
//  HuiLife
//
//  Created by 王策 on 2021/4/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HLVideoMarketModel : NSObject

@property (nonatomic, copy) NSString *id;
// 状态 0下架 1上架 10:审核中 15:审核失败
@property (nonatomic, assign) NSInteger state;
@property (nonatomic, copy) NSString *proId;
@property (nonatomic, copy) NSString *pic;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *videoUrl;
@property (nonatomic, assign) NSInteger looks;
@property (nonatomic, assign) NSInteger pays;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *reason;


///////// 方便获取
@property (nonatomic, copy) NSString *stateStr;

@end

NS_ASSUME_NONNULL_END
