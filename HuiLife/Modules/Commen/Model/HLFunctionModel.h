//
//  HLFunctionModel.h
//  HuiLife
//
//  Created by 雷清华 on 2019/8/30.
//

#import <Foundation/Foundation.h>


@interface HLFunctionModel : NSObject

@property(nonatomic,copy)NSString * title;

@property(nonatomic,copy)NSString * content;

@property(nonatomic,copy)NSString * backgroundImg;

@property(nonatomic,copy)NSString * iosArdess;

@property(nonatomic,strong)NSDictionary * iosParam;
@property (nonatomic, strong) NSDictionary *androidParam;

@end

