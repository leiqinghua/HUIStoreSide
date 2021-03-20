//
//  HLSpecialPeron.h
//  HuiLife
//
//  Created by 雷清华 on 2020/5/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HLSpecialPeron : NSObject

@property(nonatomic, copy) NSString *mobile;
//是否认证 0未认证 ，1 认证
@property(nonatomic, assign) BOOL is_authenticate;
//姓名
@property(nonatomic, copy) NSString *authenticate_name;

@property(nonatomic, copy) NSString *tipStr;

@property(nonatomic, assign) BOOL add;

@property(nonatomic, copy) NSString *mobileText;

@end


@interface HLSpecialMainInfo : NSObject
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *open_title;
@property(nonatomic, copy) NSString *open_label;
@property(nonatomic, assign) BOOL is_open;
@property(nonatomic, strong) NSArray<HLSpecialPeron *> *mobile_info;

@end

NS_ASSUME_NONNULL_END
