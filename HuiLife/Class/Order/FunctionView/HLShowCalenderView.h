//
//  HLShowCalenderView.h
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/12/24.
//

#import <UIKit/UIKit.h>

typedef void(^SelectDay)(NSString* year,NSString* month,NSString* day);

typedef void(^TouchBlock)(void);

@interface HLShowCalenderView : UIView

+ (void)calenderViewWithFrame:(CGRect)frame callBack:(SelectDay)select touch:(TouchBlock)touch;

+(void)remove;
@end

