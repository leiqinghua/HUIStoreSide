//
//  HLPrinterButton.h
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/11/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HLPrinterButton : UIView
//是否选中
@property (assign,nonatomic)BOOL selected;

-(instancetype)initWithName:(NSString *)name;

- (CGFloat)width;

//添加事件
-(void)addTarget:(NSObject *)target selecter:(SEL)selector;


@end

NS_ASSUME_NONNULL_END
