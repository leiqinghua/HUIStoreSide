//
//  HLNetWorkFailView.h
//  HuiLifeUserSide
//
//  Created by HuiLife on 2018/10/16.
//  Copyright © 2018年 wce. All rights reserved.
//

#import <UIKit/UIKit.h>

/// 主页面网络请求失败的显示的view

typedef void(^HLNetClickCallBack)(void);

@interface HLNetWorkFailView : UIView

- (instancetype)initWithFrame:(CGRect)frame clickCallBack:(HLNetClickCallBack)callBack;

@end
