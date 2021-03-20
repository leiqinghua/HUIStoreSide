//
//  HLTKResonView.h
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/10/9.
//

#import <Foundation/Foundation.h>

typedef void(^SelectBlock)(NSString * title,NSInteger index);

@interface HLTKResonView : UIView

+ (void)showWithFrame:(CGRect)frame dataSource:(NSArray *)reasons selectIndex:(NSInteger)index callBack:(SelectBlock)block;

@end
