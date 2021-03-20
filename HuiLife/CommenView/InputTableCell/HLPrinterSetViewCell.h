//
//  HLPrinterSetViewCell.h
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/8/12.
//

#import "HLBaseInputViewCell.h"

@interface HLPrinterInfo:HLBaseTypeInfo

@property(nonatomic,strong)UIImage * leftImg;

@property(nonatomic,strong)UIImage * rightImg;

//额外的
@property(nonatomic,strong)id otherKey;

@property(nonatomic,assign)BOOL loading;

@end


@interface HLPrinterSetViewCell : HLBaseInputViewCell



@end

