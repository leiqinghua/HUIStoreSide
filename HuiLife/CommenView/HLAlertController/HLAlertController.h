//
//  HLAlertController.h
//  HuiLife
//
//  Created by 雷清华 on 2019/8/9.
//

#import "HLBaseViewController.h"
#import "HLAlertAction.h"

@interface HLAlertController : HLBaseViewController

@property(nonatomic,assign) CGFloat alertWidth;

-(void)addActions:(NSArray<HLAlertAction *> *)actions;

@end


