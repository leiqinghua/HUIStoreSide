//
//  HLWXAuthoView.h
//  HuiLife
//
//  Created by 雷清华 on 2019/9/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HLWXAuthoView : UIView

+(void)showWXAuthWithAuthed:(BOOL)Auth headPic:(NSString *)pic Completion:(void(^)(NSInteger))completion;

@end

NS_ASSUME_NONNULL_END
