//
//  HLOrderPartHeader.h
//  HuiLife
//
//  Created by 雷清华 on 2020/1/3.
//

#import <UIKit/UIKit.h>
#import "HLOrderOpetionDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface HLOrderPartHeader : UITableViewHeaderFooterView

@property(nonatomic, assign)BOOL partOpen;

@property(nonatomic, weak) id<HLOrderOpetionDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
