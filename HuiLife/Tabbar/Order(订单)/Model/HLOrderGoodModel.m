//
//  HLOrderGoodModel.m
//  iOS13test
//
//  Created by 雷清华 on 2019/10/30.
//  Copyright © 2019 雷清华. All rights reserved.
//

#import "HLOrderGoodModel.h"
//普通 商品
@implementation HLOrderGoodModel

@end

//汽车服务
@implementation HLOrderCarModel

-(NSString *)descText{
    return [NSString stringWithFormat:@"汽车类型：%@  服务次数：%@",_chexing,_fw_num];
}

-(NSString *)timetext{
    return [NSString stringWithFormat:@"预约时间：%@",_reserve_time];
}
@end

//hui 卡
@implementation HLHUICardGoodInfo



@end
