//
//  HLDisplayModel.h
//  HuiLife
//
//  Created by 雷清华 on 2019/11/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HLDisplayModel : NSObject

@property(nonatomic, copy)NSString *image;

@property(nonatomic, copy)NSString *url;

@property(nonatomic, copy)NSString *title;

@property(nonatomic, copy)NSString *num;
//要复制的连接
@property(nonatomic, copy)NSString *dl_url;

@end

NS_ASSUME_NONNULL_END
