//
//  HLCardPromoteSwitch.h
//  HuiLife
//
//  Created by 雷清华 on 2019/11/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HLCardPromoteType : NSObject

@property(nonatomic, copy) NSString *title;

@property(nonatomic, copy) NSString *desc;

@property(nonatomic, assign) NSInteger on;

/// 是否可以编辑，默认为YES
@property (nonatomic, assign) BOOL canEdit;

@end

NS_ASSUME_NONNULL_END
