//
//  HLBaseTableViewCell.m
//  iOS13test
//
//  Created by 雷清华 on 2019/10/16.
//  Copyright © 2019 雷清华. All rights reserved.
//

#import "HLBaseTableViewCell.h"


@interface HLBaseTableViewCell ()

@property(nonatomic, strong) UIImageView *arrow;

@end

@implementation HLBaseTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initSubView];
    }
    return self;
}

- (void)initSubView {
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _bagView = [[UIView alloc]init];
    _bagView.backgroundColor = UIColor.whiteColor;
    [self.contentView addSubview:_bagView];
    [_bagView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    _arrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow_right"]];
    [_bagView addSubview:_arrow];
    [_arrow makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-13));
        make.centerY.equalTo(self.bagView);
    }];
    
    _line = [[UIView alloc]init];
    _line.backgroundColor = UIColorFromRGB(0xECECEC);
    [self.bagView addSubview:_line];
    [_line makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(13));
        make.right.equalTo(FitPTScreen(-13));
        make.bottom.equalTo(self.bagView);
        make.height.equalTo(FitPTScreen(0.8));
    }];
    self.showLine = false;
}

- (void)showArrow:(BOOL)show {
    _arrow.hidden = !show;
}

- (void)setShowLine:(BOOL)showLine {
    _showLine = showLine;
    _line.hidden = !showLine;
}
@end
