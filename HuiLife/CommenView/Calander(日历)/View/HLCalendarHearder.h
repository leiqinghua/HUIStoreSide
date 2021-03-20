//
//  HLCalendarHearder.h
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/12/21.
//

#import <UIKit/UIKit.h>

typedef void (^leftClickBlock) (void);

typedef void (^rightClickBlock) (void);

@interface HLCalendarHearder : UIView

@property(nonatomic,copy)leftClickBlock leftClickBlock;

@property(nonatomic,copy)rightClickBlock rightClickBlock;

@property(nonatomic,assign)BOOL isShowLeftAndRightBtn; //是否显示左右两侧按钮
@property(nonatomic,strong)NSString *dateStr;

@end

