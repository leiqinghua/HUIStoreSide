//
//  HLOrderFunctionView.h
//  HuiLife
//
//  Created by 雷清华 on 2019/12/15.
//

#import <UIKit/UIKit.h>
#import "HLOrderOpetionDelegate.h"
NS_ASSUME_NONNULL_BEGIN

@class HLOrderFunctionView;
@protocol HLOrderFunctionViewDelegate <NSObject>

- (void)functionView:(HLOrderFunctionView *)functionView typeIndex:(NSInteger)index;

@optional
//处理服务器返回的按钮
- (void)functionView:(HLOrderFunctionView *)functionView funName:(NSString *)name;

@end


@interface HLOrderFunctionView : UIView

//@{tipImg:@"",funTitle:@""}
@property(nonatomic, strong)NSArray *functions;

@property(nonatomic, weak) id<HLOrderFunctionViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
