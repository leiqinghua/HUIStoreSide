//
//  HLPrinteHeader.h
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/8/12.
//

#import <UIKit/UIKit.h>

@class HLPrinteHeader;
@protocol HLPrinteHeaderDelegate <NSObject>

-(void)hlAddPrinteDevice;

@end

@interface HLPrinteHeader : UITableViewHeaderFooterView

@property(nonatomic,copy)NSString * name;

@property(nonatomic,weak)id<HLPrinteHeaderDelegate> delegate;

@end

