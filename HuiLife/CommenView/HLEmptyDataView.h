//
//  HLEmptyDataView.h
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/8/20.
//

#import <UIKit/UIKit.h>

typedef void(^RequestBlock)(void);

@interface HLEmptyDataView : UIView
//0没有数据，1没有找到相关信息
@property(copy,nonatomic)NSString * type;

//之后使用此方法
+(void)emptyViewWithFrame:(CGRect)frame superView:(UIView*)superView type:(NSString*)type balock:(RequestBlock)block;

@end
