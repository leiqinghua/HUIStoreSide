//
//  HLAlertAction.h
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/8/10.
//

#import <Foundation/Foundation.h>


typedef enum : NSUInteger {
    HLAlertActionNormal,
    HLAlertActionCancel,
} HLAlertActionType;

typedef void(^HLActionBlock)(void);

@interface HLAlertAction : NSObject

@property(nonatomic,copy)NSString * title;

@property(nonatomic,strong)UIFont * font;

@property(nonatomic,strong)UIColor * tintColor;

@property(nonatomic,assign)BOOL showLine;

@property(nonatomic,copy)HLActionBlock completion;

@property(nonatomic,assign)HLAlertActionType type;

@property(nonatomic,assign)CGFloat hight;

-(instancetype)initWithTitle:(NSString *)title color:(UIColor*)color completion:(HLActionBlock)completion;

@end

