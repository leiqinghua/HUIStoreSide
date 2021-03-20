//
//  HLStaffDetailModel.h
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/10/18.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    
    HLDefaultType,
    
    HLSwitchType,
    
} HLStaffDetailModelType;


typedef enum : NSUInteger {
    
    HLTextFieldDefaultType,
    
    HLTextFieldPassType,
    
    HLTextFieldPhoneType,
    
} HLTextFieldType;


@interface HLStaffDefaultModel : NSObject

@property(copy,nonatomic)NSString * modelID;

@property(copy,nonatomic)NSString * is_dianzhang;

@property(copy,nonatomic)NSString * is_yy;

@property(copy,nonatomic)NSString * mobile;

@property(copy,nonatomic)NSString * name;

@property(copy,nonatomic)NSString * store_id;

@property(copy,nonatomic)NSString * store_name;

@property(copy,nonatomic)NSString * user_name;

@end

@interface HLStaffDetailModel : NSObject
//用于显示
@property(copy,nonatomic)NSString * text;
//用于传给后台
@property(copy,nonatomic)NSString * value;

@property(copy,nonatomic)NSString * placeHolder;
//是否能够编辑
@property(assign,nonatomic)BOOL canEdit;
//输入的最大数量
@property(assign,nonatomic)NSInteger input_num;
//显示三角
@property(assign,nonatomic)BOOL showGoImg;

@property (copy,nonatomic)NSString * storeid;

//显示的value
@property (copy,nonatomic)NSString * showText;

@property (assign,nonatomic)HLStaffDetailModelType type;

@property (assign,nonatomic)HLTextFieldType fieldType;

@property (strong,nonatomic)NSDictionary * pargram;

-(instancetype)initWithText:(NSString *)text holder:(NSString *)placeHolder type:(HLStaffDetailModelType)type;

@end

