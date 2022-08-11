//
//  HLMatterNoteCell.m
//  HuiLife
//
//  Created by 王策 on 2019/8/27.
//

#import "HLMatterNoteCell.h"

@interface HLMatterNoteCell ()

@property (nonatomic, strong) UILabel *indexLab;
@property (nonatomic, strong) UILabel *contentLab;

@end

@implementation HLMatterNoteCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initSubUI];
    }
    return self;
}

- (void)initSubUI {
    
    _indexLab = [[UILabel alloc] init];
    [self.contentView addSubview:_indexLab];
    _indexLab.textColor = UIColor.whiteColor;
    _indexLab.textAlignment = NSTextAlignmentCenter;
    _indexLab.layer.cornerRadius = FitPTScreen(8);
    _indexLab.layer.masksToBounds = YES;
    _indexLab.backgroundColor = UIColorFromRGB(0xFFBE31);
    _indexLab.font = [UIFont systemFontOfSize:FitPTScreen(12)];
    
    _contentLab = [[UILabel alloc] init];
    [self.contentView addSubview:_contentLab];
    _contentLab.numberOfLines = 0;
    _contentLab.textColor = UIColorFromRGB(0x666666);
    _contentLab.font = [UIFont systemFontOfSize:FitPTScreen(13)];
}

- (void)setNoteLayout:(HLMatterNoteLayout *)noteLayout {
    _noteLayout = noteLayout;
    
    _indexLab.text = noteLayout.index;
    _indexLab.frame = noteLayout.indexFrame;
    _contentLab.frame = noteLayout.textFrame;
    _contentLab.attributedText = noteLayout.textAttr;
}

@end
