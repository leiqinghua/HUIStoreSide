//
//  HLBaseInputModel.h
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/8/3.
//

#import <Foundation/Foundation.h>


typedef enum : NSUInteger {
    HLBaseInputFieldType,
    HLBaseInputTextViewType,
    HLBaseInputTimeSelectType,
} HLBaseInputType;

@interface HLBaseInputModel : NSObject

@property(nonatomic,copy)NSString * text;//左侧

@property(nonatomic,copy)NSString * place;
//用于显示
@property(nonatomic,copy)NSString * value;

@property(nonatomic,copy)NSString * rightImg;

@property(nonatomic,copy)UIColor * leftTipColor;

@property(nonatomic,copy)UIColor * placeColor;

@property(nonatomic,assign)HLBaseInputType type;

//能否编辑
@property(nonatomic,assign)BOOL canEdit;

@property(nonatomic,assign)CGFloat cellHight;

@property(nonatomic,assign)BOOL hideLine;

@property(nonatomic,copy)NSString * key;

@property(nonatomic,strong)NSDictionary * pargram;

@property(nonatomic,copy)NSString * errorHint;
//是否需要检测参数
@property(nonatomic,assign)BOOL needCheck;

//检测结果
-(BOOL)checkResult;

@end

