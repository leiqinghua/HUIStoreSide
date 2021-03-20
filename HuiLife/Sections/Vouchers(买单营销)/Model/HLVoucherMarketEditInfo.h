//
//  HLVoucherMarketEditInfo.h
//  HuiLife
//
//  Created by 王策 on 2019/8/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HLVoucherMarketEditInfo : NSObject

@property (nonatomic, copy) NSString *mchntName;    // 商户名称
@property (nonatomic, copy) NSString *contactAddr;      // 商户地址
@property (nonatomic, copy) NSString *shopHeader;
@property (nonatomic, copy) NSString *shopFront;
@property (nonatomic, copy) NSString *cardNo;
@property (nonatomic, copy) NSString *pmsBankNo; // 联行号
@property (nonatomic, copy) NSString *pmsBankName;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *realName;
@property (nonatomic, copy) NSString *certNo;
@property (nonatomic, copy) NSString *licenseExpireDt;
@property (nonatomic, copy) NSString *cardStartDt;
@property (nonatomic, copy) NSString *account;
@property (nonatomic, copy) NSString *business;
@property (nonatomic, copy) NSString *rate;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *district;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *resMsg; // 审核失败，顶部的错误提示

@property (nonatomic, copy) NSString *oneClassId;
@property (nonatomic, copy) NSString *oneClassName;
@property (nonatomic, copy) NSString *twoClassId;
@property (nonatomic, copy) NSString *twoClassName;
@property (nonatomic, copy) NSString *threeClassId;
@property (nonatomic, copy) NSString *threeClassName;

@property (nonatomic, copy) NSString *certCorrect;
@property (nonatomic, copy) NSString *certMeet;
@property (nonatomic, copy) NSString *cardCorrect;
@property (nonatomic, copy) NSString *certOpposite;
@property (nonatomic, copy) NSString *weixinNum;//微信号
//身份证正面图片：certCorrect
//手持身份证图片：certMeet
//银行卡正面图片：cardCorrect
//身份证背面图片：certOpposite

@end

//mchntName    是    string    商户名称
//contactAddr    是    string    商户地址
//shopHeader    是    string    门头照
//shopFront    是    string    门脸照
//cardNo    是    int    结算卡号(银行卡号)
//pmsBankNo    是    int    联行号
//mobile    是    int    开户时绑定手机号码
//realName    是    string    开户姓名
//certNo    是    int    证件号
//licenseExpireDt    是    string    身份证到期日期
//account    是    int    账户号(11位手机号)
//business    是    string    商户经营范围
//code    是    float    商户费率
//province    是    int    省code码
//city    是    int    市code码
//district    是    int    区code码
//address    是    string    详细地址

NS_ASSUME_NONNULL_END
