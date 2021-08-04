//
//  HLMatterMainInfo.h
//  HuiLife
//
//  Created by 王策 on 2019/8/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class HLMatterMainItemInfo;
@interface HLMatterMainInfo : NSObject


@property (nonatomic, copy) NSString *codeUrl;


@property (nonatomic, copy) NSArray<HLMatterMainItemInfo *> *itemList;
@property (nonatomic, copy) NSArray *noteList;

@end

@interface HLMatterMainItemInfo : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *smallImgUrl;
@property (nonatomic, copy) NSString *bigImgUrl;
@property (nonatomic, copy) NSString *downloadUrl;

@end

NS_ASSUME_NONNULL_END
