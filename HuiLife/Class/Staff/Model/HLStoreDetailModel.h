//
//  HLStoreDetailModel.h
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/10/22.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    HLStoreDetailDefault,
    HLStoreDetailSwitch,
    HLStoreDetailLable,
    HLStoreDetailTextView
} HLStoreDetailType;

@interface HLStoreDefaultModel : NSObject

@property (copy,nonatomic)NSString *storeid;

@property (copy,nonatomic)NSString *address;

@property (strong,nonatomic)NSArray *area;

@property (strong,nonatomic)NSArray *area_code;

@property (strong,nonatomic)NSArray *shop_date;

@property (strong,nonatomic)NSArray *shop_hours;

@property (copy,nonatomic)NSString *city;

@property (copy,nonatomic)NSString *class_id;

@property (copy,nonatomic)NSString *classname;

@property (copy,nonatomic)NSString *county;

@property (copy,nonatomic)NSString *is_show;

@property (copy,nonatomic)NSString *name;

@property (copy,nonatomic)NSString *province;

@property (copy,nonatomic)NSString *service_des;

@property (copy,nonatomic)NSString *tel;
//营业时间
@property(copy,nonatomic)NSString *businessHours;

@property (copy,nonatomic)NSString *areaText;

@end

@interface HLStoreDetailModel : NSObject

@property (copy,nonatomic)NSString *text;

@property (copy,nonatomic)NSString *showText;

@property (assign,nonatomic)BOOL canEdit;

@property(copy,nonatomic)NSString * placeHolder;

@property (assign,nonatomic)HLStoreDetailType type;
//显示三角
@property(assign,nonatomic)BOOL showGoImg;
//地区
@property (strong,nonatomic) NSArray *area;
//日期
@property (strong,nonatomic) NSArray *date;
//时间
@property (strong,nonatomic) NSArray *hours;
//上传的值
@property (copy,nonatomic)NSString *value;

@property (strong,nonatomic)NSDictionary *pargram;

-(instancetype)initWithText:(NSString *)text holder:(NSString *)placeHolder type:(HLStoreDetailType)type;

@end

