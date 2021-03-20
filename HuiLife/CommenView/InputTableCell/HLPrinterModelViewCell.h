//
//  HLPrinterModelViewCell.h
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/8/12.
//

#import "HLBaseInputViewCell.h"

@protocol HLPrinterModelDelegate;
//model
@interface HLprinterModelInfo:HLBaseTypeInfo
//1.自动打印 2.手动 3.都选 4.都不选
@property(nonatomic,assign)NSInteger modelType;

@end

//cell
@interface HLPrinterModelViewCell : HLBaseInputViewCell

@property(nonatomic,weak)id<HLPrinterModelDelegate> delegate;

@end


//打印模式
@protocol HLPrinterModelDelegate <NSObject>

- (void)printeModelCell:(HLPrinterModelViewCell *)cell autoClick:(BOOL)autoClick model:(HLprinterModelInfo *)model;


@end
