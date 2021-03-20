//
//  HLUpdateAlert.h
//  HuiLifeUserSide
//
//  Created by HuiLife on 2018/10/11.
//  Copyright © 2018年 wce. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HLUpdateCallBack)(void);

@interface HLUpdateAlert : UIView

+ (void)showUpdateAlertVersion:(NSString *)version content:(NSString *)content mustUpdate:(BOOL)mustUpdate callBack:(HLUpdateCallBack)callBack;

@end
