//
//  HLSelectShowView.h
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/7/19.
//

#import <UIKit/UIKit.h>



@protocol HLSelectShowViewDelegate <NSObject>


-(void)cancelBtn:(UIButton *)sender;

@optional
-(void)concernBtn:(UIButton *)sender selectItems:(NSMutableArray *)items;

-(void)concernBtn:(UIButton *)sender selectItems:(NSMutableArray *)items begin:(NSString *)begin end:(NSString *)end;

-(void)concernBtnWihtselectItems:(NSMutableArray *)items IsOrders:(BOOL)isOrder begin:(NSString *)begin end:(NSString *)end memberNum:(NSString *)number;

//点击门店列表
-(void)selectFirstSectionWithItem:(NSDictionary *)dict;

//点击时间lable
-(void)didSelectTimeWithTag:(NSInteger)tag;

-(void)reloadContentSize:(CGSize)size;

-(void)openBtnSelected:(BOOL)select;

@end

typedef enum : NSUInteger {
    HLYGManagerListType,
    HLMDManagerListType,
    HLMDInfoSettingType,
    HLOrderListType,
} HLSelectShowViewType;
@interface HLSelectShowView : UIView
/*
 class = "\U4ed6\U7684\U95e8\U5e97";
 classname = "\U6d60\U682b\U6b91\U95c2\U3125\U7c35";
 id = 793;
 */
@property(assign,nonatomic)HLSelectShowViewType type;

@property(strong,nonatomic)NSMutableArray *dataSource;//数据源

@property(strong,nonatomic)NSMutableArray*selectItems;

@property(weak,nonatomic)id<HLSelectShowViewDelegate>delegate;
//是否显示时间轴
@property(assign,nonatomic)BOOL isShowTime;

//记录时间选择器放在哪个section
@property(assign,nonatomic)NSInteger timeAtSection;

//记录单选的section
@property(assign,nonatomic)NSInteger sigleSection;

//时间轴上的text
@property(strong,nonatomic)NSArray * timetitles;

//headerview上展开和收起的view
@property(strong,nonatomic)UIButton * openBtn;

//是否显示展开按钮
@property(assign,nonatomic)BOOL isShowOpenBtn;

@property(assign,nonatomic)NSInteger textfieldSection;
//是不是全部订单
@property(assign,nonatomic)BOOL isAllOrders;
//提现时间
@property(strong,nonatomic)NSArray * beginAndEnd;

@property(copy,nonatomic)NSString * memberText;
//是否是年月日或年月
@property(assign,nonatomic)BOOL isDate;

//是否展开
@property(assign,nonatomic)BOOL isOpen;

@property(assign,nonatomic)float max_hight;

-(void)reloadViews;

@end
