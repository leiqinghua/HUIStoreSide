//
//  HLWithdrawView.h
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/12/26.
//

#import <UIKit/UIKit.h>

typedef void(^PayBlock)(NSInteger selectIndex);

@interface HLWithdrawView : UIView


+(void)withDrawWithMoeny:(NSString *)money selectIndex:(NSInteger)index callBack:(PayBlock)block;

+(void)withDrawWithMoeny:(NSString *)money isTx:(BOOL)isTx selectIndex:(NSInteger)index callBack:(PayBlock)block;

@end

//提现方式
@interface HLWithdrawWayView : UIView

@property(copy,nonatomic)NSString *img;

@property(copy,nonatomic)NSString *name;

@property(assign,nonatomic)BOOL isSelected;

@end
