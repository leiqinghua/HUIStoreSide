//
//  HLGuideMask.m
//  HuiLife
//
//  Created by 王策 on 2019/10/15.
//

#import "HLGuideMask.h"
#import "HLGuideMaskView.h"


@interface HLGuideMask ()

@property (nonatomic, strong) HLGuideMaskView *maskView;

@end

@implementation HLGuideMask

-(HLGuideMaskView *)maskView{
    if (!_maskView) {
        _maskView = [[HLGuideMaskView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    }
    return _maskView;
}

- (void)showMaskWithType:(HLGuideMaskType)maskType maskFrame:(CGRect)maskFrame clickBlock:(HLGuideMaskClickBlock)clickBlock{
    HLGuideLayout *layout = [HLGuideMask layoutWithMaskType:maskType maskFrame:maskFrame];
    [self.maskView drawWithGuideLayout:layout clickBlock:clickBlock];
    [KEY_WINDOW addSubview:self.maskView];
}

- (void)showMaskWithTypes:(NSArray *)types maskFrames:(NSArray *)maskFrames clickBlock:(HLGuideMaskClickBlock)clickBlock{
    if (types.count != maskFrames.count) {
        return;
    }
    
    NSMutableArray *layouts = [NSMutableArray array];
    for (NSInteger i = 0; i < types.count; i++) {
        HLGuideMaskType type = [types[i] integerValue];
        CGRect maskFrame = [maskFrames[i] CGRectValue];
        [layouts addObject:[HLGuideMask layoutWithMaskType:type maskFrame:maskFrame]];
    }
    
    [self.maskView drawWithGuideLayoutArr:layouts clickBlock:clickBlock];
    [KEY_WINDOW addSubview:self.maskView];
}

- (void)hideGuideView{
    [self.maskView removeFromSuperview];
}

// 是否展示过引导图
+ (BOOL)alreadyShowGuide{
    NSString *hasShow = [[NSUserDefaults standardUserDefaults] objectForKey:kGuideMaskNo1To5HasShow];
    return hasShow.integerValue == 1;
}

// 设置展示过引导图
+ (void)configShowGuide{
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:kGuideMaskNo1To5HasShow];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

// 本地判断是否要展示step1
+ (BOOL)needShowStep1{
    NSString *hasShow = [[NSUserDefaults standardUserDefaults] objectForKey:kGuideMaskStep1HasShow];
    return hasShow.integerValue != 1;
}

// 清除本地是否展示step1的标志
+ (void)cleanStep1ShowFlag{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kGuideMaskStep1HasShow];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

// 配置step1展示的标志
+ (void)configStep1ShowFlag{
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:kGuideMaskStep1HasShow];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

// 本地判断是否要展示step2
+ (BOOL)needShowStep2{
    NSString *hasShow = [[NSUserDefaults standardUserDefaults] objectForKey:kGuideMaskStep2HasShow];
    return hasShow.integerValue != 1;
}
// 清除本地是否展示step2的标志
+ (void)cleanStep2ShowFlag{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kGuideMaskStep2HasShow];
    [[NSUserDefaults standardUserDefaults] synchronize];

}
// 配置step2展示的标志
+ (void)configStep2ShowFlag{
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:kGuideMaskStep2HasShow];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (HLGuideLayout *)layoutWithMaskType:(HLGuideMaskType)maskType maskFrame:(CGRect)maskFrame{
    switch (maskType) {
        case HLGuideMaskTypeNo1:
            return [self typeNo1Layout:maskFrame];
            break;
        case HLGuideMaskTypeNo2:
            return [self typeNo2Layout:maskFrame];
            break;
        case HLGuideMaskTypeNo3:
            return [self typeNo3Layout:maskFrame];
            break;
        case HLGuideMaskTypeNo4:
            return [self typeNo4Layout:maskFrame];
            break;
        case HLGuideMaskTypeNo5:
            return [self typeNo5Layout:maskFrame];
            break;
        case HLGuideMaskTypeStep1:
            return [self typeStep1Layout:maskFrame];
            break;
        case HLGuideMaskTypeStep2:
            return [self typeStep2Layout:maskFrame];
            break;
        case HLGuideMaskTypeStep3:
            return [self typeStep3Layout:maskFrame];
            break;
        default:
            return [self typeNo1Layout:maskFrame];
            break;
    }
}

+ (HLGuideLayout *)typeStep3Layout:(CGRect)maskFrame{
    HLGuideLayout *layout = [[HLGuideLayout alloc] init];
    layout.maskFrame = maskFrame;
    
    layout.textImage = @"guide_step3_text_bg";
    CGFloat textImageW = FitPTScreen(174);
    CGFloat textImageH = FitPTScreen(156);
    CGFloat textImageX = FitPTScreen(74);
    CGFloat textImageY = CGRectGetMinY(maskFrame) - textImageH;
    layout.textImageFrame = CGRectMake(textImageX, textImageY, textImageW, textImageH);
    
    layout.hideBtnImage = @"guide_ok_bg";
    CGFloat hideBtnImageW = FitPTScreen(96);
    CGFloat hideBtnImageH = FitPTScreen(41);
    CGFloat hideBtnImageX = CGRectGetMaxX(maskFrame) + FitPTScreen(20);
    CGFloat hideBtnImageY = CGRectGetMaxY(layout.textImageFrame) + FitPTScreen(28);
    layout.hideBtnImageFrame = CGRectMake(hideBtnImageX, hideBtnImageY, hideBtnImageW, hideBtnImageH);
    
    layout.clickBtnImage = @"guide_post_bg";
    CGFloat clickBtnImageW = FitPTScreen(101);
    CGFloat clickBtnImageH = FitPTScreen(40);
    CGFloat clickBtnImageX = CGRectGetMaxX(layout.hideBtnImageFrame) + FitPTScreen(20);
    CGFloat clickBtnImageY = CGRectGetMinY(layout.hideBtnImageFrame);
    layout.clickBtnImageFrame = CGRectMake(clickBtnImageX, clickBtnImageY, clickBtnImageW, clickBtnImageH);
    
    return layout;
}

+ (HLGuideLayout *)typeStep2Layout:(CGRect)maskFrame{
    HLGuideLayout *layout = [[HLGuideLayout alloc] init];
    layout.maskFrame = maskFrame;
    
    layout.textImage = @"guide_step2_text_bg";
    CGFloat textImageW = FitPTScreen(206);
    CGFloat textImageH = FitPTScreen(145);
    CGFloat textImageX = CGRectGetMaxX(maskFrame) - FitPTScreen(10) - textImageW;
    CGFloat textImageY = CGRectGetMinY(maskFrame) - FitPTScreen(5) - textImageH;
    layout.textImageFrame = CGRectMake(textImageX, textImageY, textImageW, textImageH);
    
    layout.clickBtnImage = @"guide_set_bg";
    CGFloat clickBtnImageW = FitPTScreen(101);
    CGFloat clickBtnImageH = FitPTScreen(40);
    CGFloat clickBtnImageX = CGRectGetMinX(layout.textImageFrame) + FitPTScreen(10);
    CGFloat clickBtnImageY = CGRectGetMaxY(layout.textImageFrame) - FitPTScreen(10) - clickBtnImageH;
    layout.clickBtnImageFrame = CGRectMake(clickBtnImageX, clickBtnImageY, clickBtnImageW, clickBtnImageH);
    
    layout.hideBtnImage = @"guide_ok_bg";
    CGFloat hideBtnImageW = FitPTScreen(96);
    CGFloat hideBtnImageH = FitPTScreen(41);
    CGFloat hideBtnImageX = FitPTScreen(20);
    CGFloat hideBtnImageY = clickBtnImageY;
    layout.hideBtnImageFrame = CGRectMake(hideBtnImageX, hideBtnImageY, hideBtnImageW, hideBtnImageH);
    
    return layout;
}

+ (HLGuideLayout *)typeStep1Layout:(CGRect)maskFrame{
    HLGuideLayout *layout = [[HLGuideLayout alloc] init];
    layout.maskFrame = maskFrame;
    
    layout.textImage = @"guide_step1_text_bg";
    CGFloat textImageW = FitPTScreen(224);
    CGFloat textImageH = FitPTScreen(120);
    CGFloat textImageX = CGRectGetMinX(maskFrame) - textImageW + FitPTScreen(15);
    CGFloat textImageY = CGRectGetMaxY(maskFrame) + FitPTScreen(10);
    layout.textImageFrame = CGRectMake(textImageX, textImageY, textImageW, textImageH);
    
    layout.hideBtnImage = @"guide_ok_bg";
    CGFloat hideBtnImageW = FitPTScreen(96);
    CGFloat hideBtnImageH = FitPTScreen(41);
    CGFloat hideBtnImageX = CGRectGetMinX(layout.textImageFrame);
    CGFloat hideBtnImageY = CGRectGetMaxY(layout.textImageFrame) + FitPTScreen(48);
    layout.hideBtnImageFrame = CGRectMake(hideBtnImageX, hideBtnImageY, hideBtnImageW, hideBtnImageH);
    
    layout.clickBtnImage = @"guide_upload_bg";
    CGFloat clickBtnImageW = FitPTScreen(103);
    CGFloat clickBtnImageH = FitPTScreen(40);
    CGFloat clickBtnImageX = CGRectGetMinX(layout.textImageFrame) + FitPTScreen(115);
    CGFloat clickBtnImageY = CGRectGetMaxY(layout.textImageFrame) + FitPTScreen(48);
    layout.clickBtnImageFrame = CGRectMake(clickBtnImageX, clickBtnImageY, clickBtnImageW, clickBtnImageH);
    
    return layout;
}

+ (HLGuideLayout *)typeNo5Layout:(CGRect)maskFrame{
    HLGuideLayout *layout = [[HLGuideLayout alloc] init];
    layout.maskFrame = maskFrame;
    
    layout.textImage = @"guide_no5_text_bg";
    CGFloat textImageW = FitPTScreen(221);
    CGFloat textImageH = FitPTScreen(132);
    CGFloat textImageX = CGRectGetMinX(maskFrame) - textImageW + FitPTScreen(19);
    CGFloat textImageY = CGRectGetMaxY(maskFrame);
    layout.textImageFrame = CGRectMake(textImageX, textImageY, textImageW, textImageH);
    
    layout.clickBtnImage = @"guide_ok_bg";
    CGFloat clickBtnImageW = FitPTScreen(96);
    CGFloat clickBtnImageH = FitPTScreen(41);
    CGFloat clickBtnImageX = CGRectGetMaxX(layout.textImageFrame) - clickBtnImageW - FitPTScreen(20);
    CGFloat clickBtnImageY = CGRectGetMaxY(layout.textImageFrame) + FitPTScreen(10);
    layout.clickBtnImageFrame = CGRectMake(clickBtnImageX, clickBtnImageY, clickBtnImageW, clickBtnImageH);
    
    return layout;
}

+ (HLGuideLayout *)typeNo4Layout:(CGRect)maskFrame{
    HLGuideLayout *layout = [[HLGuideLayout alloc] init];
    layout.maskFrame = maskFrame;
    
    layout.textImage = @"guide_no4_text_bg";
    CGFloat textImageW = FitPTScreen(166);
    CGFloat textImageH = FitPTScreen(160);
    CGFloat textImageX = CGRectGetMidX(maskFrame);
    CGFloat textImageY = CGRectGetMinY(maskFrame) - textImageH - FitPTScreen(6);
    layout.textImageFrame = CGRectMake(textImageX, textImageY, textImageW, textImageH);
    
    layout.clickBtnImage = @"guide_ok_bg";
    CGFloat clickBtnImageW = FitPTScreen(96);
    CGFloat clickBtnImageH = FitPTScreen(41);
    CGFloat clickBtnImageX = CGRectGetMaxX(maskFrame) + FitPTScreen(30);
    CGFloat clickBtnImageY = CGRectGetMaxY(layout.textImageFrame) + FitPTScreen(3);
    layout.clickBtnImageFrame = CGRectMake(clickBtnImageX, clickBtnImageY, clickBtnImageW, clickBtnImageH);
    
    return layout;
}

+ (HLGuideLayout *)typeNo3Layout:(CGRect)maskFrame{
    HLGuideLayout *layout = [[HLGuideLayout alloc] init];
    layout.maskFrame = maskFrame;
    
    layout.textImage = @"guide_no3_text_bg";
    CGFloat textImageW = FitPTScreen(111);
    CGFloat textImageH = FitPTScreen(142);
    CGFloat textImageX = CGRectGetMaxX(maskFrame) + FitPTScreen(6);
    CGFloat textImageY = CGRectGetMinY(maskFrame) - textImageH + FitPTScreen(6);
    layout.textImageFrame = CGRectMake(textImageX, textImageY, textImageW, textImageH);
    
    layout.clickBtnImage = @"guide_ok_bg";
    CGFloat clickBtnImageW = FitPTScreen(96);
    CGFloat clickBtnImageH = FitPTScreen(41);
    CGFloat clickBtnImageX = CGRectGetMaxX(maskFrame) + FitPTScreen(20);
    CGFloat clickBtnImageY = CGRectGetMaxY(layout.textImageFrame) + FitPTScreen(30);
    layout.clickBtnImageFrame = CGRectMake(clickBtnImageX, clickBtnImageY, clickBtnImageW, clickBtnImageH);
    
    return layout;
}

+ (HLGuideLayout *)typeNo2Layout:(CGRect)maskFrame{
    HLGuideLayout *layout = [[HLGuideLayout alloc] init];
    layout.maskFrame = maskFrame;
//    guide_no3_text_bg
    layout.textImage = @"guide_no2_text_bg";
    CGFloat textImageW = FitPTScreen(133);
    CGFloat textImageH = FitPTScreen(147);
    CGFloat textImageX = CGRectGetMaxX(maskFrame);
    CGFloat textImageY = CGRectGetMinY(maskFrame) - textImageH;
    layout.textImageFrame = CGRectMake(textImageX, textImageY, textImageW, textImageH);
    
    layout.clickBtnImage = @"guide_ok_bg";
    CGFloat clickBtnImageW = FitPTScreen(96);
    CGFloat clickBtnImageH = FitPTScreen(41);
    CGFloat clickBtnImageX = CGRectGetMaxX(maskFrame) + FitPTScreen(20);
    CGFloat clickBtnImageY = CGRectGetMaxY(layout.textImageFrame) + FitPTScreen(20);
    layout.clickBtnImageFrame = CGRectMake(clickBtnImageX, clickBtnImageY, clickBtnImageW, clickBtnImageH);
    
    return layout;
}

+ (HLGuideLayout *)typeNo1Layout:(CGRect)maskFrame{
    HLGuideLayout *layout = [[HLGuideLayout alloc] init];
    layout.maskFrame = maskFrame;
    
    layout.textImage = @"guide_no1_text_bg";
    CGFloat textImageW = FitPTScreen(179);
    CGFloat textImageH = FitPTScreen(84);
    CGFloat textImageX = CGRectGetMinX(maskFrame) - FitPTScreen(2) - textImageW;
    CGFloat textImageY = CGRectGetMaxY(maskFrame) + FitPTScreen(2);
    layout.textImageFrame = CGRectMake(textImageX, textImageY, textImageW, textImageH);
    
    layout.clickBtnImage = @"guide_ok_bg";
    CGFloat clickBtnImageW = FitPTScreen(96);
    CGFloat clickBtnImageH = FitPTScreen(41);
    CGFloat clickBtnImageX = CGRectGetMinX(layout.textImageFrame) + FitPTScreen(100);
    CGFloat clickBtnImageY = CGRectGetMaxY(layout.textImageFrame) + FitPTScreen(28);
    layout.clickBtnImageFrame = CGRectMake(clickBtnImageX, clickBtnImageY, clickBtnImageW, clickBtnImageH);
    
    return layout;
}



//HLGuideMaskTypeNo1,
//HLGuideMaskTypeNo2,
//HLGuideMaskTypeNo3,
//HLGuideMaskTypeNo4,
//HLGuideMaskTypeNo5,
//HLGuideMaskTypeStep1,
//HLGuideMaskTypeStep2,
//HLGuideMaskTypeStep3

@end
