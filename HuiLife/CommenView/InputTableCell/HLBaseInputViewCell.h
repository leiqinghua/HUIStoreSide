//
//  HLBaseInputViewCell.h
//  HuiLife
//
//  Created by 王策 on 2019/8/2.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    HLInputCellTypeDefault, // 默认的状态，|label textfield>|
    HLInputCellTypeRightImage, // |label image|
    HLInputCellTypeRightSwitch, // |label switch|
    HLInputCellTypeDate,    //日期选择
    HLInputCellTypeRuleDesc, //规则说明
    HLInputCellTypeDownSelect, //|label 下拉选择|
    HLInputCellTypeRightBox,
    HLInputCellTypePayPromoteDay, // s买单推广，选择日期
    HLInputCellTypeAdmit,//限领
    HLInputCellTypeUseDesc,//使用说明
    HLInputCellTypeVoucherRange,
    HLInputCellTypeTGLevel, //推广强度
    HLInputCellTypeTwoImage, //推广强度
    HLInputCellPrinterType, //打印cell
    HLInputCellPrinterModel,//打印模式
    HLInputCellRightButton, //成团时间
    HLInputCellRightEditNum,//编辑折扣(+ -)
    HLInputPickImagesType,//选择图片
    HLInputRedPacketClassType // hui卡外卖红包类别样式
} HLInputCellType;

@interface HLBaseTypeInfo : NSObject

/// 类型
@property (nonatomic, assign) HLInputCellType type;

/// 高度
@property (nonatomic, assign) CGFloat cellHeight;

/// 底部先距离左边的距离，默认是 0 26 0 12
@property (nonatomic, assign) UIEdgeInsets separatorInset;

/// 是否可以交互，默认为yes, 当输入页面不可编辑时可用,否则，选择图片或别的的时候，判断如果为no，则不处理任何事件
/// 谨慎设置 ***** 当输入页面不可编辑时才可以用 ****
@property (nonatomic, assign) BOOL enabled;

/// 最左边的提示文字
@property (nonatomic, copy) NSString * _Nullable leftTip;
/// 左边的富文本缓存，直接取
@property (nonatomic, copy) NSAttributedString *leftTipAttr;

/// 服务端保存的参数名称
@property (nonatomic, copy) NSString *saveKey;
/// 需要提交给服务端的数据
@property (nonatomic, copy) NSDictionary *mParams;
/// 设置的右边输入框的文字展示,如果只需要一个参数，那么text就是saveKey对应的值
@property (nonatomic, copy) NSString *text;

/// 错误的提示，如果需求条件不满足的错误提示，弹窗提示
@property (nonatomic, copy) NSString *errorHint;

//左边lable 的字体颜色
@property (nonatomic, strong) UIColor *leftTipColor;

/// 是否需要判断错误,需要的话则会执行 checkParamsIsOk 方法
@property (nonatomic, assign) BOOL needCheckParams;
/// 判断条件是否满足，需要子类重写，如果不需要条件，则直接返回YES
- (BOOL)checkParamsIsOk;

@end

NS_ASSUME_NONNULL_BEGIN

@interface HLBaseInputViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *leftTipLab;

@property (nonatomic, strong) HLBaseTypeInfo *baseInfo;

/// 底部的线
@property (nonatomic, strong) UIView *bottomLine;

/// 是否展示自己添加的bottomLine, 默认为no，只有group style 下，可能会用到
@property (nonatomic, assign) BOOL showBottomLine;

- (void)initSubUI;

@end

NS_ASSUME_NONNULL_END
