//
//  HLBuyCardPackageItemView.m
//  HuiLife
//
//  Created by 王策 on 2021/3/20.
//

#import "HLBuyCardPackageItemView.h"

@implementation HLBuyCardPackageViewItem

- (BOOL)isCustom{
    return [self.num isEqualToString:@"自定义"];
}

@end

@interface HLBuyCardPackageItemView ()

@property (nonatomic, strong) UILabel *numLab;
@property (nonatomic, strong) UILabel *giveNumLab;

@end

@implementation HLBuyCardPackageItemView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.layer.cornerRadius = FitPTScreen(2.5);
        self.layer.masksToBounds = YES;
        [self creatSubViews];
    }
    return self;
}

- (void)creatSubViews{
    self.numLab = [[UILabel alloc] init];
    self.numLab.font = [UIFont boldSystemFontOfSize:FitPTScreen(14)];
    [self addSubview:self.numLab];
    
    self.giveNumLab = [[UILabel alloc] init];
    self.giveNumLab.font = [UIFont systemFontOfSize:FitPTScreen(12)];
    [self addSubview:self.giveNumLab];
    [self.giveNumLab makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.numLab.bottom).offset(FitPTScreen(3));
        make.width.lessThanOrEqualTo(self.width);
    }];
    
}

- (void)setItem:(HLBuyCardPackageViewItem *)item{
    _item = item;
    
    self.numLab.text = [NSString stringWithFormat:@"%@张",item.num];
    self.giveNumLab.text = [NSString stringWithFormat:@"送%@张",item.gife];
    self.giveNumLab.hidden = item.gife.intValue <= 0;
    
    if (item.isCustom) {
        self.numLab.text = @"自定义";
    }
    
    if(item.gife.intValue > 0){
        [self.numLab makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(FitPTScreen(14));
            make.width.lessThanOrEqualTo(self.width);
        }];
    }else{
        [self.numLab makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.width.lessThanOrEqualTo(self.width);
        }];
    }
    
    // 控制状态显示
    [self resetViewsState];
}

- (void)resetViewsState{
    self.backgroundColor = self.item.select ? [UIColor hl_StringToColor:@"#FD9E2F"] : [UIColor hl_StringToColor:@"#F8F8F8"];
    self.numLab.textColor = self.item.select ? [UIColor hl_StringToColor:@"#FFFFFF"] : [UIColor hl_StringToColor:@"#333333"];
    self.giveNumLab.textColor = self.item.select ? [UIColor hl_StringToColor:@"#FFFFFF"] : [UIColor hl_StringToColor:@"#FD9E2F"];
}

@end
