//
//  HLMarketMainModel.h
//  HuiLife
//
//  Created by 雷清华 on 2019/8/15.
//

#import <Foundation/Foundation.h>

@interface HLMarketMainModel : NSObject

@property(nonatomic,copy)NSString * name;

@property(nonatomic,copy)NSString * state;

@property(nonatomic,copy)NSString * iosArdess;

@property(nonatomic,copy)NSString * backgroundImg;

@property(nonatomic,copy)NSString * fontColor;

@property(nonatomic,strong)NSDictionary * iosParam;

@end

