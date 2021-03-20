//
//  HLAddPrinterTableViewCell.h
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/11/23.
//lable and textField

#import <UIKit/UIKit.h>
#import "HLPrinterSetModel.h"
//#import "HLTextFieldCheckInputNumberTool.h"

@protocol HLAddPrinterTableViewCellDelegate <NSObject>

-(void)editWithModel:(HLPrinterSetModel *)model key:(NSString *)key;

@end

@interface HLAddPrinterTableViewCell : UITableViewCell

@property(strong,nonatomic)HLPrinterSetModel * model;

@property (copy,nonatomic)NSString * key;

@property (weak,nonatomic)id<HLAddPrinterTableViewCellDelegate> delegate;

-(void)updateLineWithTopHiden:(BOOL)top bottomHiden:(BOOL)bottom topFull:(BOOL)topFull bottomFull:(BOOL)bottomFull;


@end

