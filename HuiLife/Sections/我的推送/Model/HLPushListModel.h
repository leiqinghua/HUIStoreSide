//
//  HLPushListModel.h
//  HuiLife
//
//  Created by 王策 on 2021/4/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HLPushListModel : NSObject

@property (nonatomic, copy) NSString *push_id;
@property (nonatomic, copy) NSString *date;
@property (nonatomic, copy) NSString *title;
// 0 活动推送  10 审核中 // 15 审核失败
@property (nonatomic, assign) NSInteger state;
@property (nonatomic, copy) NSString *pro_id;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *describe;
@property (nonatomic, assign) NSInteger total;
@property (nonatomic, assign) NSInteger open;
@property (nonatomic, assign) NSInteger buy;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) double price;
@property (nonatomic, assign) double sale;

@end

NS_ASSUME_NONNULL_END
