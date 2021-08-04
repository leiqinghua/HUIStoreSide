//
//  HLOrderLRTableCell.m
//  iOS13test
//
//  Created by 雷清华 on 2019/10/30.
//  Copyright © 2019 雷清华. All rights reserved.
//

#import "HLOrderLRTableCell.h"

@interface HLOrderLRTableCell ()

@property(nonatomic, strong) NSMutableArray<UILabel *> *titleLbs;

@property(nonatomic, strong) NSMutableArray<UILabel *> *valueLbs;

@end

@implementation HLOrderLRTableCell

- (void)initSubView {
    [super initSubView];
    [self showArrow:false];
}

- (void)setContents:(NSArray *)contents {
    if ([contents isEqual:_contents]) {
        return;
    }
    _contents = contents;
    
    [_titleLbs enumerateObjectsUsingBlock:^(UILabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
        obj = nil;
    }];
    
    [_valueLbs enumerateObjectsUsingBlock:^(UILabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
        obj = nil;
    }];
    [self.titleLbs removeAllObjects];
    [self.valueLbs removeAllObjects];
    
    [self layoutSubLables];
}

- (void)layoutSubLables {
    for (int i= 0; i<_contents.count; i++) {
        NSDictionary * dict = _contents[i];
        UILabel * title = [[UILabel alloc]init];
        title.textColor = UIColorFromRGB(0x868686);
        title.text = dict[@"key"];
        title.font = [UIFont systemFontOfSize:FitPTScreen(14)];
        [self addSubview:title];
        [self.titleLbs addObject:title];
        [title makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(FitPTScreen(20));
            make.top.equalTo(i==0?self:self.titleLbs[i-1].bottom).offset(FitPTScreen(20));
        }];
        
        UILabel * value = [[UILabel alloc]init];
        value.textColor = UIColorFromRGB(0x333333);
        value.font = [UIFont systemFontOfSize:FitPTScreen(14)];
        [self addSubview:value];
        value.text =  dict[@"value"];
        [self.valueLbs addObject:value];
        [value makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(FitPTScreen(-20));
            make.centerY.equalTo(self.titleLbs[i]);
        }];
    }
}


- (NSMutableArray<UILabel *> *)titleLbs {
    if (!_titleLbs) {
        _titleLbs = [NSMutableArray array];
    }
    return _titleLbs;
}

- (NSMutableArray<UILabel *> *)valueLbs {
    if (!_valueLbs) {
        _valueLbs = [NSMutableArray array];
    }
    return _valueLbs;
}

@end
