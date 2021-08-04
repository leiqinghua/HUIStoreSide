//
//  HLPrinterDeviceHeaderView.h
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/11/22.
//

#import <UIKit/UIKit.h>

@protocol HLPrinterDeviceHeaderViewDelegate <NSObject>

//添加打印机
- (void)addPrinter;

@end

NS_ASSUME_NONNULL_BEGIN

@interface HLPrinterDeviceHeaderView : UIView

@property (weak,nonatomic)id<HLPrinterDeviceHeaderViewDelegate>delegate;

-(instancetype)initWithFrame:(CGRect)frame title:(NSString *)title showAdd:(BOOL)show;

-(void)showBottomLine:(BOOL)show;

@end

NS_ASSUME_NONNULL_END
