//
//  HLTools.h
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/7/30.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "HLBaseViewController.h"

@interface HLTools : NSObject

@property(strong,nonatomic)NSArray * loadingImages;

//黑色吐司弹框
+ (void)showWithText:(NSString *)text;

+ (void)showHint:(NSString *)hint inView:(UIView*)view;

//  展示菊花加载
+ (void)showLoadingInView:(UIView *)view;

+ (void)hideLoadingForView:(UIView *)view;

+ (void)startLoadingAnimation;

+ (void)endLoadingAnimation ;

//获取本地版本
+ (NSString *)currentVersion;

+ (void)gotoAppstore;


+ (void)callPhone:(NSString *)phoneText;

//获取当前控制器
+ (HLBaseViewController *)visiableController;

+ (MainTabBarController *)rootViewController;

//自适应宽度
+ (CGFloat)estmateWidthString:(NSString *)string Font:(UIFont *)font;

//自适应高度
+ (CGFloat)estmateHightString:(NSString *)string Font:(UIFont *)font;

+ (CGFloat)estmateHightString:(NSString *)string Font:(UIFont *)font lineSpace:(NSInteger)space;

+ (CGFloat)estmateHightString:(NSString *)string Font:(UIFont *)font lineSpace:(NSInteger)space maxWidth:(CGFloat)width ;

//添加线
+ (UIView *)lineWithGap:(CGFloat)gap topMargn:(CGFloat)margn;

+ (NSMutableAttributedString *)attrStringWithString:(NSString *)string lineSpace:(CGFloat)lineSpace kern:(CGFloat)kern;

// 富文本大小
+ (CGSize)attrSizeWithString:(NSString *)string lineSpace:(CGFloat)lineSpace kern:(CGFloat)kern font:(UIFont *)font width:(CGFloat)width;

//跳转到设置页面
+ (void)openSystemSetting;

//与存储日期是否相差一天
+(BOOL)compareOneDay;

//存储日期
+ (void)storeDate:(NSDate *)date;

//将date 格式化字符串
+ (NSString *)formatterWithDate:(NSDate *)date formate:(NSString *)formate;

//将格式化字符串转换成date
+(NSDate*)dateWithFormatter:(NSString *)formatter dateStr:(NSString*)date;

//两个日期比较
+(NSInteger)compareWithFirst:(NSString *)dateStr1 another:(NSString*)dateStr2 formate:(NSString*)formate;

// 保存图片z到本地
+ (void)saveImageToLocal:(UIImage *)image;

// 压缩图片 byte为单位的
+ (NSData *)compressImage:(UIImage *)image toByte:(NSUInteger)maxLength;

+ (CGSize)stringSizeWithString:(NSString *)string fontSize:(CGFloat)fontSize height:(CGFloat)height;

/// 跳转app内指定页面，根据页面路径和参数字典跳转
+ (void)pushAppPageLink:(NSString *)link params:(NSDictionary *)params needBack:(BOOL)needBack;

/// 颜色转换
/// @param colorStr 色值字符串
/// @param alpha 透明度
+ (UIColor *)hl_toColorByColorStr:(NSString *)colorStr alpha:(CGFloat)alpha;

//颜色转换
+(UIColor *)hl_toColorByColorStr:(NSString *)colorStr;

+ (NSString *)safeStringObject:(id)object;

//四舍五入保留两位小数
+ (CGFloat)decimalwithFloatNum:(float)floatNum;

//隐藏电话的中间四位
+(NSString *)getMiddleHideTextWithPhoneNum:(NSString *)phoneNum;


//存储数据到userdefaults
+(void)storeValue:(NSString *)value forKey:(NSString *)key;

//取出数据
+(NSString *)valueForKey:(NSString *)key;

//转字符串
+(NSString *)toStringWithObj:(id)obj;

//copy 相册视频到APP
+(NSString *)filePathWithSystemPath:(NSString *)path;

//将毫秒转换成格式字符串
+ (NSString * )convertStrToTime:(NSString *)timeStr;

//获取视频缩略图
+ (UIImage *)getScreenShotImageFromVideoPath:(NSString *)filePath;

//将图片存储到沙盒

+(NSString *)saveImageWithImage:(NSData *)imageData;


//水平方向滚动到中心点
+ (CGPoint)hl_horizontalWithScroll:(UIScrollView *)scroll scrollWidth:(CGFloat)width selectItem:(UIView *)item;

// 图片裁减时的尺寸比例 宽: 高 type 1卡 2券 3爆款抢购商品 4限时抢购  5店铺 6买单加购
+ (void)loadImageResizeScaleWithType:(NSInteger)type controller:(UIViewController *)controller completion:(void(^)(double mainScale, double subScale))completion;

@end
