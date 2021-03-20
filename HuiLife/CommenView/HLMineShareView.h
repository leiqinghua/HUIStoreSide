//
//  HLMineShareView.h
//  HuiLifeUserSide
//
//  Created by 王策 on 2018/9/10.
//  Copyright © 2018年 wce. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HLShareCallBack)(NSInteger type);

@interface HLMineShareView : UIView

+ (void)showShareViewWithCallBack:(HLShareCallBack)callBack;

@end
