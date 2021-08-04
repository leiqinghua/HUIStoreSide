//
//  HLMatterNoteLayout.h
//  HuiLife
//
//  Created by 王策 on 2019/8/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HLMatterNoteLayout : NSObject

@property (nonatomic, copy) NSString *index;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSAttributedString *textAttr;

@property (nonatomic, assign) CGRect indexFrame;
@property (nonatomic, assign) CGRect textFrame;

@property (nonatomic, assign) CGFloat cellHeight;

@end

NS_ASSUME_NONNULL_END
