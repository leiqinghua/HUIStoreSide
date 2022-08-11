//
//  HLBottomControlView.m
//  HuiLife
//
//  Created by 王策 on 2019/8/6.
//

#import "HLBottomControlView.h"

#define kRowHeight FitPTScreen(130)
const NSInteger kItemLabTag = 999;

@interface HLBottomControlView ()

/// 根据文字 取type
@property (nonatomic, copy) NSDictionary *typeDict;
/// 根据type 取文字和图片
@property (nonatomic, copy) NSDictionary *imagesDict;

@property (nonatomic, copy) NSArray *titles;

@property (strong, nonatomic) UIView *mainView;

@property (copy, nonatomic) HLControlCallBack callBack;

@end

@implementation HLBottomControlView


+ (void) showControlView:(NSInteger)upState onlyUpdate:(BOOL)onlyUpdate callBack:(HLControlCallBack)callBack {
//    HLBottomControlView *controlView = [[HLBottomControlView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.frame upState:upState onlyUpdate:onlyUpdate];
//    controlView.callBack = callBack;
//    [controlView show];
}

+ (void)showControlViewWithItemTitles:(NSArray *)titles callBack:(HLControlCallBack)callBack{
    HLBottomControlView *controlView = [[HLBottomControlView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.bounds titles:titles];
    controlView.callBack = callBack;
    [controlView show];
}

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0];
        _titles = titles;
        [self initSubViews];
    }
    return self;
}

- (CGFloat)mainViewHeight{
    return ((_titles.count - 1) / 4 + 1 ) * kRowHeight + Height_Bottom_Margn;
}

- (void)initSubViews {
    
    [self hl_addTarget:self action:@selector(hide)];
    
    // mainVi
    _mainView = [[UIView alloc] init];
    [self addSubview:_mainView];
    _mainView.backgroundColor = UIColorFromRGB(0xFFFFFF);
    _mainView.frame = CGRectMake(0, ScreenH, ScreenW, [self mainViewHeight]);
    [_mainView hl_addTarget:nil action:nil];
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:_mainView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(FitPTScreen(14), FitPTScreen(14))];
    layer.path = bezierPath.CGPath;
    _mainView.layer.mask = layer;
    
//    FitPTScreen(25)
    CGFloat leftMargin = FitPTScreen(13);
    // o判断有几行 2 3
    CGFloat itemWidth = (ScreenW - leftMargin * 2) / 4;
    
    for (NSInteger i = 0; i < self.titles.count; i++) {
        
        NSInteger row = i / 4;
        NSInteger col = i % 4;
        
        NSString *title = self.titles[i];
        UIView *bottomItem = [self creatTopSubItemView:self.imagesDict[title] title:title];
        [self.mainView addSubview:bottomItem];
        [bottomItem makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(itemWidth * col + leftMargin);
            make.top.equalTo(kRowHeight * row);
            make.height.equalTo(kRowHeight);
            make.width.equalTo(itemWidth);
        }];
        [bottomItem hl_addTarget:self action:@selector(itemClick:)];
    }
}

- (void)itemClick:(UITapGestureRecognizer *)tap {
    UIView *item = tap.view;
    UILabel *label = [item viewWithTag:kItemLabTag];
    HLControlType type = [self.typeDict[label.text] integerValue];
    if (self.callBack) {
        self.callBack(type);
    }
    [self hide];
}

/// 上面三个按钮
- (UIView *)creatTopSubItemView:(NSString *)imageName title:(NSString *)title {
    
    UIView *subItem = [[UIView alloc] init];
    
    UIImageView *imgV = [[UIImageView alloc] init];
    [subItem addSubview:imgV];
    imgV.image = [UIImage imageNamed:imageName];
    [imgV makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(FitPTScreen(17));
        make.centerX.equalTo(subItem);
        make.width.height.equalTo(FitPTScreen(75));
    }];
    
    UILabel *label = [[UILabel alloc] init];
    [subItem addSubview:label];
    label.text = title;
    label.tag = kItemLabTag;
    label.textColor = UIColorFromRGB(0x333333);
    label.font = [UIFont systemFontOfSize:FitPTScreen(13)];
    [label makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imgV.bottom).offset(FitPTScreen(-3));
        make.centerX.equalTo(imgV);
    }];
    return subItem;
}

- (void)buttonClick:(UIButton *)sender {
    if (self.callBack) {
        self.callBack(sender.tag);
        [self hide];
    }
}

#pragma mark - Public Method

- (void)show {
    [[[UIApplication sharedApplication].delegate window] addSubview:self];
    // 展示出来
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
                         _mainView.frame = CGRectMake(0, ScreenH - [self mainViewHeight], ScreenW, [self mainViewHeight]);
                     }];
}

- (void)hide {
    [self endEditing:YES];
    [UIView animateWithDuration:0.25
                     animations:^{
                         _mainView.frame = CGRectMake(0, ScreenH, ScreenW, [self mainViewHeight]);
                         self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0];
                     }
                     completion:^(BOOL finished) {
                         [self removeFromSuperview];
                     }];
}

- (NSDictionary *)typeDict {
    if (!_typeDict) {
        _typeDict = @{
                      @"微信朋友圈": @(HLControlTypeWXCycle),
                      @"微信好友": @(HLControlTypeWXChat),
                      @"推送": @(HLControlTypePush),
                      @"预览": @(HLControlTypePreView),
                      @"数据概览": @(HLControlTypeDataView),
                      @"二维码下载": @(HLControlTypeQRCode),
                      @"生成展架":@(HLControlTypeDisplay),
                      @"删除" : @(HLControlTypeDeleteCard),
                      @"修改" : @(HLControlTypeEditCard),
                      @"生成卡密" : @(HLControlTypeCreateCard),
                      @"下架" : @(HLControlTypeStateDown),
                      @"上架" :@(HLControlTypeStateUp)
                      };
    }
    return _typeDict;
}

- (NSDictionary *)imagesDict{
    if (!_imagesDict) {
        _imagesDict = @{
                        @"微信朋友圈": @"bottom_control_wxcycle",
                        @"微信好友": @"bottom_control_wxchat",
                        @"推送": @"bottom_control_push",
                        @"预览": @"bottom_control_preview",
                        @"数据概览": @"bottom_control_dataview",
                        @"二维码下载": @"bottom_control_qrcode",
                        @"生成展架"  : @"bottom_control_display",
                        @"删除" : @"bottom_control_delete",
                        @"修改" : @"bottom_control_edit",
                        @"生成卡密" : @"bottom_control_secret",
                        @"下架" : @"bottom_control_down",
                        @"上架": @"bottom_control_up"
                        };
    }
    return _imagesDict;
}

@end
