//
//  HLMonthModel.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/3/22.
//

#import "HLMonthModel.h"

@interface HLMonthModel()
//行数
@property(assign,nonatomic)NSInteger rows;

@end

@implementation HLMonthModel

-(NSString *)title{
    return [NSString stringWithFormat:@"%ld年 %ld月",_year,_month];
}

-(NSInteger)rows{
    NSInteger row = (self.days.count -1)/7;
    return row + 1;
}

-(CGFloat)hight{
    return FitPTScreenH(50)*self.rows;
}

@end
