//
//  HLLBHeaderView.h
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/7/23.
//

#import <UIKit/UIKit.h>

@protocol HLLBHeaderViewDelegate <NSObject>

-(void)tapTheViewSelect:(BOOL )select indexpath:(NSInteger )index;

//为某个大类添加小类
-(void)addSmallClassAtIndexPath:(NSInteger)section className:(NSString *)name;

-(void)deleteBigClassAtIndexPath:(NSInteger)section ;
//取消第一响应
-(void)cancelFirstResponder;
@end

@interface HLLBHeaderView : UITableViewHeaderFooterView

@property(strong,nonatomic)UILabel * titleLable;

@property(strong,nonatomic)UIButton *sanjiao;

//是否是选择类别
@property(assign,nonatomic)BOOL isSelect;

//让section聚合
@property(assign,nonatomic)BOOL tapSelect;

@property(weak,nonatomic)id<HLLBHeaderViewDelegate>delegate;

@property(assign,nonatomic)NSInteger index;

//- (instancetype)initWithIndex:(NSInteger)index;
-(void)hideBottomLine:(BOOL)hide;

-(void)setSelectLB:(BOOL)isSelect;

@end
