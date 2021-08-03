//
//  NSObject+HLExtension.h
//  HuiLifeUserSide
//
//  Created by HuiLife on 2018/11/28.
//  Copyright © 2018 wce. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (HLExtension)

//检测是否是nil 是否是 nsnull
- (BOOL)hl_isAvailable;

//数组里面是不是全是空的
- (BOOL)isEmptyArr;

+ (NSArray *)allKeysWithDictionary:(NSDictionary *)dict;

+ (NSArray *)allValuesWithDictionary:(NSDictionary *)dict;
/**
 *  自动生成属性列表
*/
+ (void)printPropertyWithDict:(NSDictionary *)dict;

/**
 方法交换
 */
+ (BOOL)jr_swizzleMethod:(SEL)origSel_ withMethod:(SEL)altSel_ error:(NSError**)error_;
+ (BOOL)jr_swizzleClassMethod:(SEL)origSel_ withClassMethod:(SEL)altSel_ error:(NSError**)error_;

@end

NS_ASSUME_NONNULL_END
