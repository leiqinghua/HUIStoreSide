//
//  HLRedBagAddFooter.m
//  HuiLife
//
//  Created by 雷清华 on 2020/11/16.
//

#import "HLRedBagAddFooter.h"
#import "HLRedBagInfo.h"
@interface HLRedBagAddFooter ()
@property(nonatomic, strong) HLRedBagSetView *redBagSetView;
@property(nonatomic, strong) UILabel *contentLb;
@end
@implementation HLRedBagAddFooter

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.clearColor;
        _redBagSetView = [[HLRedBagSetView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, FitPTScreen(348))];
        [self addSubview:_redBagSetView];
        _redBagSetView.backgroundColor = UIColor.whiteColor;
        _redBagSetView.title = @"设置推广红包";
        _redBagSetView.priceTitle = @"总金额";
        _redBagSetView.pricePlace = @"请输入红包总金额";
        _redBagSetView.numTitle = @"红包个数";
        _redBagSetView.numPlace = @"请输入红包个数";
        _redBagSetView.times = @[@"10天",@"30天",@"领完为止"];
        
        UILabel *tip = [UILabel hl_regularWithColor:@"#666666" font:12];
        tip.text = @"红包推广说明";
        [self addSubview:tip];
        [tip makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(FitPTScreen(12));
            make.top.equalTo(self.redBagSetView.bottom).offset(FitPTScreen(18));
        }];
        
        _contentLb = [UILabel hl_lableWithColor:@"#666666" font:12 bold:NO numbers:0];
        [self addSubview:_contentLb];
        [_contentLb makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(FitPTScreen(12));
            make.top.equalTo(tip.bottom).offset(FitPTScreen(13));
        }];
        NSString *content = @"按照红包金额收取1%的服务费\n期限内未领完，将自动款原支付账户";
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
        style.lineSpacing = 5;
        NSAttributedString *mutarr = [[NSAttributedString alloc]initWithString:content attributes:@{NSParagraphStyleAttributeName:style}];
        _contentLb.attributedText = mutarr;
    }
    return self;
}

- (void)setRedBagInfo:(HLRedBagInfo *)redBagInfo {
    _redBagInfo = redBagInfo;
    _redBagSetView.redBagInfo = redBagInfo;
    _redBagSetView.redBagInfo.timeType = [redBagInfo.rangTimes objectAtIndex:0];
    [_redBagSetView seletTimeAtIndex:0];
    [_redBagSetView selectRangeAtIndex:0];
}

- (void)setDelegate:(id<HLRedBagSetViewDelegate>)delegate {
    _redBagSetView.delegate = delegate;
}

@end
