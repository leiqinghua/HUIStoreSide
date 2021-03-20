//
//  HLOrderContentsCell.m
//  iOS13test
//
//  Created by 雷清华 on 2019/10/30.
//  Copyright © 2019 雷清华. All rights reserved.
//

#import "HLOrderContentsCell.h"

@interface HLOrderContentsCell ()

@property (strong,nonatomic)NSMutableArray<UILabel *> * contentLbs;

@end

@implementation HLOrderContentsCell

- (void)initSubView {
    [super initSubView];
    [self showArrow:false];
    UIView*line = [[UIView alloc]init];
    line.backgroundColor = UIColorFromRGB(0xDDDDDD);
    [self addSubview:line];
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(10));
        make.right.equalTo(FitPTScreen(-10));
        make.top.equalTo(self);
        make.height.equalTo(FitPTScreen(0.5));
    }];
}

- (NSMutableArray<UILabel *> *)contentLbs {
    if (!_contentLbs) {
        _contentLbs = [NSMutableArray array];
    }
    return _contentLbs;
}

- (void)setContents:(NSArray *)contents {
    if ([contents isEqual:_contents]) {
        return;
    }
    _contents = contents;
    [self.contentLbs enumerateObjectsUsingBlock:^(UILabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
        obj = nil;
    }];
    [self.contentLbs removeAllObjects];
    
    [self layoutSubLables];
}

- (void)layoutSubLables {
    for (int i=0; i<_contents.count; i++) {
        NSString *text = _contents[i];
        UILabel * contentLable = [[UILabel alloc]init];
        contentLable.textColor = UIColorFromRGB(0xFF989898);
        contentLable.font =[UIFont systemFontOfSize:FitPTScreen(14)];
        contentLable.attributedText = [self attrWithText:text];
        [self addSubview:contentLable];
        [self.contentLbs addObject:contentLable];
        [contentLable makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(FitPTScreen(10));
            make.top.equalTo(i==0?self:self.contentLbs[i-1].bottom).offset(FitPTScreen(20));
        }];
    }
}

- (NSAttributedString *)attrWithText:(NSString *)text {
    NSMutableAttributedString * attr = [[NSMutableAttributedString alloc]initWithString:text];
    NSRange range = [text rangeOfString:@"："];
    NSDictionary *dict = @{NSForegroundColorAttributeName:UIColorFromRGB(0xFF282828)};
    [attr addAttributes:dict range:NSMakeRange(range.location, text.length - range.location)];
    return attr;
}
@end
