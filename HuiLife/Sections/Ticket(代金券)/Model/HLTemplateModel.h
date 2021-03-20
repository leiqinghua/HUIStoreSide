//
//  HLTemplateModel.h
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/8/6.
//

#import <Foundation/Foundation.h>

@interface HLTemplateModel : NSObject

@property(nonatomic,copy)NSString * Id;

@property(nonatomic,copy)NSString * imgDesc;

@property(nonatomic,strong)UIImage * selectImg;

@property(nonatomic,copy)NSString * imgUrl;
//是否是使用中
@property(nonatomic,assign)BOOL isUse;

@property(nonatomic,assign)BOOL isDefault;

@end

