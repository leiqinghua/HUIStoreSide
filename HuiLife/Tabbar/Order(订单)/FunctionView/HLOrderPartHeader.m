//
//  HLOrderPartHeader.m
//  HuiLife
//
//  Created by 雷清华 on 2020/1/3.
//

#import "HLOrderPartHeader.h"

@interface HLOrderPartHeader ()

@property(nonatomic, strong) UILabel *titleLb;

@property(nonatomic, strong) UIView *openBtn;

@property(nonatomic, strong) UILabel *openLb;

@property(nonatomic, strong) UIImageView *openView;

@end

@implementation HLOrderPartHeader

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self initSubView];
    }
    return self;
}

- (void)initSubView {
    self.contentView.backgroundColor = UIColor.whiteColor;
    _titleLb = [UILabel hl_regularWithColor:@"#868686" font:14];
    _titleLb.text = @"部分退款";
    [self addSubview:_titleLb];
    [_titleLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(12));
        make.centerY.equalTo(self);
    }];
    
    _openBtn = [[UIView alloc]init];
    _openBtn.layer.cornerRadius = FitPTScreen(11);
    _openBtn.layer.borderColor = UIColorFromRGB(0xCDCDCD).CGColor;
    _openBtn.layer.borderWidth = FitPTScreen(0.5);
    [self addSubview:_openBtn];
    [_openBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-11));
        make.centerY.equalTo(self.titleLb);
        make.width.equalTo(FitPTScreen(54));
        make.height.equalTo(FitPTScreen(23));
    }];
    UITapGestureRecognizer *openTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openBtnClick:)];
    [_openBtn addGestureRecognizer:openTap];
    
    _openLb = [UILabel hl_regularWithColor:@"#666666" font:12];
    _openLb.text = @"展开";
    [_openBtn addSubview:_openLb];
    [_openLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(9));
        make.centerY.equalTo(self.openBtn);
    }];
    
    _openView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow_xia"]];
    [_openBtn addSubview:_openView];
    [_openView makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-6));
        make.centerY.equalTo(self.openBtn);
    }];
}

- (void)openBtnClick:(UITapGestureRecognizer *)sender {
    self.partOpen = !self.partOpen;
    if ([self.delegate respondsToSelector:@selector(hl_headerViewWithOpenClick:)]) {
        [self.delegate hl_headerViewWithOpenClick:self.partOpen];
    }
}

- (void)setPartOpen:(BOOL)partOpen {
    _partOpen = partOpen;
    _openLb.text = _partOpen ? @"收起" : @"展开";
    _openView.image = [UIImage imageNamed:_partOpen?@"arrow_up_grey":@"arrow_down_grey_light"];
}

@end
