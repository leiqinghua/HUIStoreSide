//
//  HLExpressionView.h
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/12/17.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    HLExpressionSettlementType,//结算金额
    HLExpressionAcceptTKType,//收到退款金额
    HLExpressionBearTKType,//商家承担
} HLExpressionViewType;

@class HLExpressionView;

@protocol HLExpressionViewDelegate <NSObject>

-(void)expressView:(HLExpressionView*)view click:(UIButton*)sender;

@end

NS_ASSUME_NONNULL_BEGIN

@interface HLExpressionView : UIView

//是不是部分退款
@property(assign,nonatomic)BOOL isSection;

@property (assign,nonatomic)BOOL show;

@property (assign,nonatomic)BOOL showLine;

@property (assign,nonatomic)BOOL isSelected;

@property(weak,nonatomic)id<HLExpressionViewDelegate>delegate;

-(instancetype)initWithFrame:(CGRect)frame show:(BOOL)show;

-(void)setContent:(NSString *)money type:(HLExpressionViewType)type;

//退款页面 展示价格
-(void)showPrice:(NSString *)price;

@end

NS_ASSUME_NONNULL_END
