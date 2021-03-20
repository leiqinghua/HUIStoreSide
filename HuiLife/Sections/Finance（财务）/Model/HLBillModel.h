//
//  HLBillModel.h
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/12/27.
//

#import <Foundation/Foundation.h>

@interface HLBillModel : NSObject

@property(copy,nonatomic)NSString* Id;

@property(copy,nonatomic)NSString* cj_time;

@property(copy,nonatomic)NSString* leixing;

@property(copy,nonatomic)NSString* price;
//18扫码点餐
@property(assign,nonatomic)NSInteger type;

@property(assign,nonatomic)BOOL is_zf;

@property(copy,nonatomic)NSString *pic;

@property(copy,nonatomic)NSString *desc;


@property(assign,nonatomic)BOOL hideLine;

//上圆角
@property(assign,nonatomic)BOOL topCorner;

@property(assign,nonatomic)BOOL bottomCorner;

@property(strong,nonatomic)NSAttributedString* priceAttr;

@end

