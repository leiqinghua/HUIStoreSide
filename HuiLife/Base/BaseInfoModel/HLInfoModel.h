//
//  HLInfoModel.h
//  HuiLife
//
//  Created by 雷清华 on 2019/8/27.
//

#import <Foundation/Foundation.h>


typedef enum : NSUInteger {
    HLInfoModelNormal,
    HLInfoModelYZM,//验证码
    HLInfoCollegeDesType,
    HLInfoCollegePassword,
} HLInfoModelType;


@interface HLInfoModel : NSObject

@property(nonatomic,copy)NSString * leftPic;

@property(nonatomic,copy)NSString * leftText;

@property(nonatomic,copy)NSString * placeHolder;

@property(nonatomic,copy)NSString * text;

@property(nonatomic,assign)BOOL canInput;

@property(nonatomic,assign)BOOL showArrow;

@property(nonatomic,assign)BOOL phone;

@property(nonatomic,copy)NSString * tip;

@property(nonatomic,assign)HLInfoModelType type;

@property(nonatomic,assign)UIKeyboardType keyboardType;

@property(nonatomic,assign)CGFloat cellHight;

@property(nonatomic,copy)NSString * errorHint;

@property(nonatomic,copy)NSDictionary * pargram;

@property (nonatomic, assign) BOOL entry;

@property(nonatomic,copy)NSString * key;

@property (nonatomic, assign) BOOL needCheckParams;

- (BOOL)checkParamsIsOk;

@end

