//
//  HLBuyCardListViewCell.h
//  HuiLife
//
//  Created by 王策 on 2021/3/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface HLBuyCardListViewModel : NSObject
// 提示
@property (nonatomic, copy) NSString *tip;
// 输入框提示
@property (nonatomic, copy) NSString *placeHolder;
// 键盘类型
@property (nonatomic, assign) UIKeyboardType keyboardType;
// 是否可以编辑
@property (nonatomic, assign) BOOL canEdit;
// 输入的数据
@property (nonatomic, assign) NSString *inputValue;

@end

@interface HLBuyCardListViewCell : UITableViewCell

@property (nonatomic, strong) HLBuyCardListViewModel *listModel;

@end

NS_ASSUME_NONNULL_END
