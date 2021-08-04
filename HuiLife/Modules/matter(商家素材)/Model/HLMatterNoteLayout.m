//
//  HLMatterNoteLayout.m
//  HuiLife
//
//  Created by 王策 on 2019/8/27.
//

#import "HLMatterNoteLayout.h"

@implementation HLMatterNoteLayout

- (CGFloat)cellHeight {
    if (_cellHeight == 0) {
        
        _indexFrame = CGRectMake(FitPTScreen(16), FitPTScreen(5), FitPTScreen(16), FitPTScreen(16));
        
        _textAttr = [HLTools attrStringWithString:_text lineSpace:FitPTScreen(3) kern:0];
        CGSize size = [HLTools attrSizeWithString:_text lineSpace:FitPTScreen(3) kern:0 font:[UIFont systemFontOfSize:FitPTScreen(13)] width:FitPTScreen(242)];
        _textFrame = CGRectMake(CGRectGetMaxX(_indexFrame) + FitPTScreen(10), FitPTScreen(5), FitPTScreen(242), size.height);
        
        _cellHeight = CGRectGetMaxY(_textFrame) + FitPTScreen(17);
    }
    return _cellHeight;
}

@end
