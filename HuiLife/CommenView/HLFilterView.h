//
//  HLFilterView.h
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/11/15.
//筛选

#import <UIKit/UIKit.h>


@interface HLFilterModel : NSObject

@property(copy,nonatomic)NSString * title;

@property(copy,nonatomic)NSString *Id;

@property(assign,nonatomic)BOOL selected;

@end


@protocol HLFilterViewDelegate <NSObject>

@end

//筛选日期（订单部分）
typedef void(^DateSelectBlock)(NSInteger clickIndex,NSArray* dates,NSArray *selectItems);

@interface HLFilterView : UIView

@property(weak,nonatomic)id<HLFilterViewDelegate> delegate;


+(void)showSelectViewWithSectionTitles:(NSArray *)titles dataSource:(NSArray *)dataSource dates:(NSArray *)dates callBack:(DateSelectBlock)callBack;

+(void)remove;

@end



