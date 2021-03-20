//
//  HLPrinterSettingViewCell.h
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/11/22.
//打印机设置

#import <UIKit/UIKit.h>
#import "HLPrinterSetModel.h"

@class HLPrinterSettingViewCell;

@protocol HLPrinterSettingViewCellDelegate <NSObject>

-(void)tableVeiwCell:(HLPrinterSettingViewCell *)cell showDevicesWithON:(BOOL)on;

@end

@interface HLPrinterSettingViewCell : UITableViewCell

@property (strong,nonatomic)HLPrinterSetModel * model;

@property (weak,nonatomic)id<HLPrinterSettingViewCellDelegate>delegate;

-(void)showTopLine:(BOOL)show gap:(CGFloat)gap;

@end

