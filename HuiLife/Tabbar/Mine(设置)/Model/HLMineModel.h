//
//  HLMineModel.h
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/11/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HLMineModel : NSObject

@property (copy,nonatomic)NSString * icon;

@property (copy,nonatomic)NSString * title;

@property (copy,nonatomic)NSString * describe;

@property (copy,nonatomic)NSString * name;

@property (copy,nonatomic)NSString * phoneNum;

@property (copy,nonatomic)NSString * iosAddress;

@property (strong,nonatomic)NSDictionary * iosParam;
@end

NS_ASSUME_NONNULL_END
