//
//  HLPlayManager.h
//  HuiLifeUserSide
//
//  Created by 王策 on 2019/7/26.
//  Copyright © 2019 wce. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HLPlayManager : HLBaseViewController

@property (nonatomic, copy) NSString *centerTitle;

- (instancetype)initWithVideoUrl:(NSString *)videoUrl preImgUrl:(NSString *)preImgUrl;

@end

NS_ASSUME_NONNULL_END
