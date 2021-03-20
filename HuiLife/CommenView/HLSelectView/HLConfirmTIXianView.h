//
//  HLConfirmTIXianView.h
//  HuiLife
//
//  Created by 雷清华 on 2018/7/18.
//

#import <UIKit/UIKit.h>

@protocol HLConfirmTIXianViewDelegate <NSObject>

-(void)concernTiXian:(UIButton *)sender;

@end

@interface HLConfirmTIXianView : UIView

@property(copy,nonatomic)NSString *money;

@property(weak,nonatomic)id<HLConfirmTIXianViewDelegate>delegate;
@end
