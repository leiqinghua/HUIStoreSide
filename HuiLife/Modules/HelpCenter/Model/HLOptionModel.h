//
//  HLOptionModel.h
//  HuiLife
//
//  Created by 雷清华 on 2019/10/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HLOptionModel : NSObject

@property(nonatomic, copy) NSString *content;

@property(nonatomic, copy) NSString *input_time;

@property(nonatomic, copy) NSString *title;

@property(nonatomic, assign) NSInteger num;

@property(nonatomic, copy) NSString *pic;
//时间
@property(nonatomic, copy) NSString *duration;
//视频地址
@property(nonatomic, copy) NSString *address;

@end

NS_ASSUME_NONNULL_END
