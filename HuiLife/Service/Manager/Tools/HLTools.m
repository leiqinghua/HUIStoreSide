//
//  HLTools.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/7/30.
//

#import "HLTools.h"
#import <SDWebImageDownloader.h>
#import "HLBaseViewController.h"
#import "HLNavigationController.h"
#import <UIKit/UIKit.h>

static UIView *_loadingBackground;

static UIImageView *_loadingIV;


//static

@implementation HLTools

+(void)showWithText:(NSString *)text{
    dispatch_main_async_safe(^{
        MBProgressHUD * hud = [[MBProgressHUD alloc] initWithView:KEY_WINDOW];
        hud.mode = MBProgressHUDModeText;
        hud.bezelView.backgroundColor = [UIColor blackColor];
        hud.label.textColor = [UIColor whiteColor];
        [KEY_WINDOW addSubview:hud];
        hud.label.text = text;
        [hud showAnimated:YES];
        [hud hideAnimated:YES afterDelay:1.5];
        // 隐藏时候从父控件中移除
        hud.removeFromSuperViewOnHide = YES;
    });
}

+ (void)showHint:(NSString *)hint inView:(UIView*)view{
    dispatch_main_async_safe(^{
        MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:view?:KEY_WINDOW];
        hud.contentColor = [UIColor whiteColor];
        hud.bezelView.color = [UIColor blackColor];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = hint;
        hud.label.font = [UIFont systemFontOfSize:14];
        hud.removeFromSuperViewOnHide = YES;
        [view?:KEY_WINDOW addSubview:hud];
        [hud showAnimated:YES];
        [hud hideAnimated:YES afterDelay:1];
    });
}


//  展示菊花加载
+ (void)showLoadingInView:(UIView *)view{
    __block UIView *showView = view;
    dispatch_main_async_safe(^{
        if (!showView) {
            showView = KEY_WINDOW;
        }
        MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:showView];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.animationType  = MBProgressHUDAnimationZoom;
        hud.removeFromSuperViewOnHide = YES;
        hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
        hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.02f];
        hud.label.text = @"加载中";
        [showView addSubview:hud];
        [hud showAnimated:YES];
    });
}

+ (void)hideLoadingForView:(UIView *)view{
    __block UIView *showView = view;
    dispatch_main_async_safe(^{
        if (!showView) {
            showView = KEY_WINDOW;
        }
        NSEnumerator *subviewsEnum = [showView.subviews reverseObjectEnumerator];
        for (UIView *subview in subviewsEnum) {
            if ([subview isKindOfClass:[MBProgressHUD class]] && [(MBProgressHUD *)subview mode] == MBProgressHUDModeIndeterminate) {
                MBProgressHUD *hud = (MBProgressHUD *)subview;
                [hud hideAnimated:YES];
            }
        }
    });
}


+ (void)startLoadingAnimation {
    if (_loadingBackground) {
        [_loadingBackground removeFromSuperview];
        _loadingBackground = nil;
    }
    _loadingBackground = [[UIView alloc] init];
    [KEY_WINDOW addSubview:_loadingBackground];
    _loadingBackground.backgroundColor = [UIColor clearColor];
    [_loadingBackground makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(KEY_WINDOW.mas_left);
        make.right.equalTo(KEY_WINDOW.mas_right);
        make.width.equalTo(KEY_WINDOW.mas_width);
        make.height.equalTo(KEY_WINDOW.mas_height);
    }];
    
    _loadingIV = [[UIImageView alloc] init];
    [_loadingBackground addSubview:_loadingIV];
    _loadingIV.alpha = 0;
    NSMutableArray *images = [NSMutableArray array];
    for (int i = 1; i < 13; i++) {
        NSString *path = [NSString stringWithFormat:@"%d",i];
        UIImage *img = [UIImage imageNamed:path];
        [images addObject:img];
    }
    [_loadingIV setAnimationImages:images];
    _loadingIV.animationDuration = 1;
    _loadingIV.animationRepeatCount = 0;
    [_loadingIV makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_loadingBackground.mas_centerX);
        make.centerY.equalTo(_loadingBackground.mas_centerY);
        make.width.equalTo(FitPTScreen(29));
        make.height.equalTo(FitPTScreen(29));
    }];
    [UIView animateWithDuration:0.2 animations:^{
        _loadingIV.alpha = 1;
    } completion:^(BOOL finished) {
        [_loadingIV startAnimating];
    }];
}

+ (void)endLoadingAnimation {
    [_loadingIV stopAnimating];
    [UIView animateWithDuration:0.2 animations:^{
        _loadingIV.alpha = 0;
    } completion:^(BOOL finished) {
        [_loadingBackground removeFromSuperview];
        _loadingBackground = nil;
    }];
}


+ (void)callPhone:(NSString *)phoneText{
    NSMutableString * str = [[NSMutableString alloc] initWithFormat:@"tel://%@",phoneText];
    NSString *version= [UIDevice currentDevice].systemVersion;
    if(version.doubleValue >=10.2) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:phoneText preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        }];
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"呼叫" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:otherAction];
        HLBaseViewController * vc = [self visiableController];
        [vc presentViewController:alertController animated:YES completion:nil];
    }
}

+(HLBaseViewController *)visiableController {
    if ([self rootViewController]) {
        MainTabBarController * mainTab = [self rootViewController];
        HLNavigationController * navi = mainTab.childViewControllers[mainTab.selectedIndex];
        return (HLBaseViewController *)navi.topViewController;
    }
    HLNavigationController * navi = (HLNavigationController *)KEY_WINDOW.rootViewController;
    return (HLBaseViewController *)navi.topViewController;
}


+ (MainTabBarController *)rootViewController{
    UIViewController * rootVC = KEY_WINDOW.rootViewController;
    if ([rootVC isKindOfClass:[MainTabBarController class]]) {
        return (MainTabBarController *)rootVC;
    }
    return nil;
}

+ (CGFloat)estmateWidthString:(NSString *)string Font:(UIFont *)font{
    NSDictionary *dic = @{NSFontAttributeName:font};//指定字号
    CGRect rect = [string boundingRectWithSize:CGSizeMake(MAXFLOAT,0) options:NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading attributes:dic context:nil];
    
    return rect.size.width;
}

+ (CGFloat)estmateHightString:(NSString *)string Font:(UIFont *)font{
    NSDictionary *dic = @{NSFontAttributeName:font};//指定字号
    CGRect rect = [string boundingRectWithSize:CGSizeMake(ScreenW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading attributes:dic context:nil];
    
    return rect.size.height;
}

+ (CGFloat)estmateHightString:(NSString *)string Font:(UIFont *)font lineSpace:(NSInteger)space maxWidth:(CGFloat)width {
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
    style.lineSpacing = space;
    NSDictionary *dic = @{NSFontAttributeName:font,NSParagraphStyleAttributeName:style};//指定字号
    CGRect rect = [string boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading attributes:dic context:nil];
    
    return rect.size.height;
}

+ (CGFloat)estmateHightString:(NSString *)string Font:(UIFont *)font lineSpace:(NSInteger)space{
    
    return [self estmateHightString:string Font:font lineSpace:space maxWidth:ScreenW];
}

+ (UIView *)lineWithGap:(CGFloat)gap topMargn:(CGFloat)margn{
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(gap, margn, ScreenW - gap*2, FitPTScreen(0.7))];
    line.backgroundColor = UIColorFromRGB(0xDDDDDD);
    return line;
}

+ (NSMutableAttributedString *)attrStringWithString:(NSString *)string lineSpace:(CGFloat)lineSpace kern:(CGFloat)kern{
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    //调整行间距
    paragraphStyle.lineSpacing = lineSpace;
    NSDictionary *attriDict = @{NSParagraphStyleAttributeName:paragraphStyle,
                                NSKernAttributeName:@(kern)
                                };
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:string attributes:attriDict];
    return attributedString;
}

+ (CGSize)attrSizeWithString:(NSString *)string lineSpace:(CGFloat)lineSpace kern:(CGFloat)kern font:(UIFont *)font width:(CGFloat)width {
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineSpacing = lineSpace;
    NSDictionary *attriDict = @{
                                NSParagraphStyleAttributeName:paragraphStyle,
                                NSKernAttributeName:@(kern),
                                NSFontAttributeName:font};
    CGSize size = [string boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attriDict context:nil].size;
    return size;
}

//获取本地版本
+ (NSString *)currentVersion{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    return app_Version;
}

+ (void)gotoAppstore{
    NSString * url = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=%@",@"1436931000"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

/// 跳转到设置页面
+ (void)openSystemSetting{
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if (@available(iOS 10.0, *)) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
    } else {
        if ([[UIApplication sharedApplication] canOpenURL:url]){
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}


//存储数据到userdefaults
+(void)storeValue:(NSString *)value forKey:(NSString *)key{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:value forKey:key];
    [userDefaults synchronize];
}

//取出数据
+(NSString *)valueForKey:(NSString *)key{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults valueForKey:key];
}

//存储日期
+(void)storeDate:(NSDate *)date{
    NSString * str = [self formatterWithDate:date formate:@"yyyy-MM-dd HH:mm:ss"];
    [self storeValue:str forKey:hl_update_date];
}

//将date 格式化字符串
+(NSString *)formatterWithDate:(NSDate *)date formate:(NSString *)formate{
    // 实例化NSDateFormatter
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 设置日期格式
    [formatter setDateFormat:formate];
    NSString *dateString = [formatter stringFromDate:date];
    return dateString;
}

//将格式化字符串转换成date
+(NSDate*)dateWithFormatter:(NSString *)formatter dateStr:(NSString*)date{
    NSDateFormatter *formate = [[NSDateFormatter alloc] init];
    [formate setDateFormat:formatter];
    [formate setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    NSDate *someDay = [formate dateFromString:date];
    return someDay;
}

//与存储日期是否相差一天
+(BOOL)compareOneDay{
    NSDate * curDate = [NSDate date];
    NSString * dateStr = [self valueForKey:hl_update_date];
    if (!dateStr) {
//        存储到本地
        [self storeDate:[NSDate date]];
        return YES;
    }
    NSDate * compareDate = [self dateWithFormatter:@"yyyy-MM-dd HH:mm:ss" dateStr:dateStr];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitDay;
    NSDateComponents *delta = [calendar components:unit fromDate:compareDate toDate:curDate options:0];
    return delta.day >=1;
}

//两个日期比较
+ (NSInteger)compareWithFirst:(NSString *)dateStr1 another:(NSString*)dateStr2 formate:(NSString*)formate{
    NSInteger compare;
    NSDate * date1 = [self dateWithFormatter:formate dateStr:dateStr1];
    NSDate *date2 =[self dateWithFormatter:formate dateStr:dateStr2];
    NSComparisonResult result = [date1 compare:date2];
    if (result==NSOrderedSame)
    {//date1=date2
        compare = 0;
    }else if (result==NSOrderedAscending)
    {
        compare=1;//date1<date2
    }else{
        compare=-1;//date1>date2
    }
    return compare;
}

// 保存图片z到本地
+ (void)saveImageToLocal:(UIImage *)image{
    // 保存到本地
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

// 保存图片回调
+ (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSString *msg = nil ;
    if(error){
        msg = @"保存图片失败" ;
    }else{
        msg = @"保存图片成功" ;
    }
    HLShowText(msg);
}

// 压缩图片
+ (NSData *)compressImage:(UIImage *)image toByte:(NSUInteger)maxLength {
    // Compress by quality
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(image, compression);
    if (data.length < maxLength) return data;
    
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(image, compression);
        if (data.length < maxLength * 0.9) {
            min = compression;
        } else if (data.length > maxLength) {
            max = compression;
        } else {
            break;
        }
    }
    UIImage *resultImage = [UIImage imageWithData:data];
    if (data.length < maxLength) return data;
    
    // Compress by size
    NSUInteger lastDataLength = 0;
    while (data.length > maxLength && data.length != lastDataLength) {
        lastDataLength = data.length;
        CGFloat ratio = (CGFloat)maxLength / data.length;
        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                 (NSUInteger)(resultImage.size.height * sqrtf(ratio))); // Use NSUInteger to prevent white blank
        UIGraphicsBeginImageContext(size);
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        data = UIImageJPEGRepresentation(resultImage, compression);
    }
    
    return data;
}

+ (CGSize)stringSizeWithString:(NSString *)string fontSize:(CGFloat)fontSize height:(CGFloat)height{
    CGSize size = [string boundingRectWithSize:CGSizeMake(MAXFLOAT, height) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size;
    return size;
}

/// 跳转app内指定页面，根据页面路径和参数字典跳转
+ (void)pushAppPageLink:(NSString *)link params:(NSDictionary *)params needBack:(BOOL)needBack{
    // 为空判断
    if(!link || link.length == 0)return;
    HLBaseViewController *vc = [[NSClassFromString(link) alloc] init];
    if (vc) {
        for (NSString *key in params.allKeys) {
            [vc setValue:params[key]?:@"" forKey:key];
        }
        UIViewController *rootVC = KEY_WINDOW.rootViewController;
        if ([rootVC isKindOfClass:[MainTabBarController class]]) {
            MainTabBarController *tabBar = (MainTabBarController *)rootVC;
            HLNavigationController *nav = tabBar.viewControllers[tabBar.selectedIndex];
            if (needBack) {
                HLBaseViewController *topVC = nav.viewControllers.firstObject;
                nav.viewControllers = @[topVC];
            }
            [nav pushViewController:vc animated:YES];
        }else if([rootVC isKindOfClass:[HLNavigationController class]]){
            HLNavigationController *nav = (HLNavigationController *)rootVC;
            if (needBack) {
                HLBaseViewController *topVC = nav.viewControllers.firstObject;
                nav.viewControllers = @[topVC];
            }
            [nav pushViewController:vc animated:YES];
        }
        
    }
}

+ (UIColor *)hl_toColorByColorStr:(NSString *)colorStr alpha:(CGFloat)alpha {
//    给字符串去掉空格 并 转成大写
    NSString *cString = [[colorStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
       if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
       if ([cString length] != 6){
           return [UIColor blackColor];
       }
       NSRange range;
       range.location = 0;
       range.length = 2;
       NSString *rString = [cString substringWithRange:range];
       range.location = 2;
       NSString *gString = [cString substringWithRange:range];
       range.location = 4;
       NSString *bString = [cString substringWithRange:range];
       unsigned int r, g, b;
       [[NSScanner scannerWithString:rString] scanHexInt:&r];
       [[NSScanner scannerWithString:gString] scanHexInt:&g];
       [[NSScanner scannerWithString:bString] scanHexInt:&b];
       return [UIColor colorWithRed:((float) r / 255.0f)green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:alpha];
}

+ (UIColor *)hl_toColorByColorStr:(NSString *)colorStr {
    return [self hl_toColorByColorStr:colorStr alpha:1.0];
}

+ (NSString *)safeStringObject:(id)object{
    if ([object respondsToSelector:@selector(length)]) {
        return object;
    }else{
        return [object stringValue];
    }
}


+(CGFloat)decimalwithFloatNum:(float)floatNum{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPositiveFormat:@"0.00"];
    NSNumber * number = [numberFormatter numberFromString:[NSString stringWithFormat:@"%lf",floatNum]];
    return number.floatValue;
}

+ (NSString *)getMiddleHideTextWithPhoneNum:(NSString *)phoneNum{
    if (!phoneNum.length) {
        return nil;
    }
    NSString *MOBILE = @"^1(3[0-9]|4[56789]|5[0-9]|6[6]|7[0-9]|8[0-9]|9[189])\\d{8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    BOOL isOk = [regextestmobile evaluateWithObject:phoneNum];
    if (isOk) {//如果是手机号码的话
        NSString *numberString = [phoneNum stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        return numberString;
    }
    return phoneNum;
}


+(NSString *)toStringWithObj:(id)obj{
    if ([obj isKindOfClass:[NSString class]]) {
        return obj;
    }
    if ([obj isKindOfClass:[NSNumber class]]) {
        if (((NSNumber *)obj).doubleValue == 0) {
            return @"0";
        }
      return [NSString stringWithFormat:@"%lf",((NSNumber *)obj).doubleValue];
    }
    if (!obj) {
        return @"";
    }
    return [NSString stringWithFormat:@"%@",obj];
}


//将相册视频copy到本APP中
+(NSString *)filePathWithSystemPath:(NSString *)path{
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yy-MM-dd-HH:mm:ss"];
    NSString * filePath = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@", [[formater stringFromDate:[NSDate date]] stringByAppendingString:@".mp4"]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSError *error;
    [fileManager copyItemAtPath:path toPath:filePath error:&error];
    if (error)
    {
        HLLog(@"文件保存到缓存失败");
    }
    return filePath;
}

//将毫秒转换成格式字符串
+ (NSString * )convertStrToTime:(NSString *)timeStr{
    long long time=[timeStr longLongValue];
    long ms = time%1000/10;
    long second = time/1000%60;
    long m = time/1000/60;
//    :%02ld
    NSString *timeString =[NSString stringWithFormat:@"%02ld:%02ld",m,second];
    return timeString;
  
}

//获取视频缩略图
+ (UIImage *)getScreenShotImageFromVideoPath:(NSString *)filePath{
    
    UIImage *shotImage;
    //视频路径URL
    NSURL *fileURL = [NSURL fileURLWithPath:filePath];
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:fileURL options:nil];
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    shotImage = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return shotImage;
    
}


+ (NSString *)saveImageWithImage:(NSData *)imageData{
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yy-MM-dd-HH:mm:ss"];
    NSString * filePath = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@", [[formater stringFromDate:[NSDate date]] stringByAppendingString:@".png"]];
    
    BOOL error = [imageData writeToFile:filePath atomically:YES];
    if (!error) {
        HLLog(@"保存失败");
    }
    return filePath;
}

//水平方向滚动到中心点
+ (CGPoint)hl_horizontalWithScroll:(UIScrollView *)scroll scrollWidth:(CGFloat)width selectItem:(UIView *)item{
    
    CGRect itemRect = item.frame;
    // 所点击的item的中心点
    CGFloat itemCenterX = CGRectGetMidX(itemRect);
    // scrollview的中心点的位置 frame的中心点
    CGFloat scrollCenterX = width / 2;
    // 当前的移动的x
    CGFloat offsetX = scroll.contentOffset.x;
    // 两个中心点的差距
    CGFloat margen = itemCenterX - scrollCenterX;
    //与中心点相隔的距离
    CGFloat margen_x = itemCenterX - offsetX - scrollCenterX;
    //最大的offset_x
    CGFloat max_offx = scroll.contentSize.width - scrollCenterX * 2;
    if (margen_x < 0) {//右滚
        margen = offsetX < - margen_x ? offsetX : margen;
        // 正好在中心点
        if (margen == offsetX && offsetX > 0) {
            margen = 0;
        }
    }else{
        margen = margen >= max_offx ? max_offx : margen;
    }
    
    return CGPointMake(margen, 0);
}

// 图片裁减时的尺寸比例 宽: 高 type 1卡 2券 3爆款抢购商品(主图、副图) 4限时抢购(主图、副图) 5店铺(店铺图册、店内环境图册)
+ (void)loadImageResizeScaleWithType:(NSInteger)type controller:(UIViewController *)controller completion:(void(^)(double mainScale, double subScale))completion{
    HLLoading(controller.view);
    
    __block double mainScale = [self defaultMainScaleWithType:type];
    __block double subScale = [self defaultSubScaleWithType:type];
    
    [XMCenter sendRequest:^(XMRequest * _Nonnull request) {
        request.api = @"/MerchantSideA/AlbumSize.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = @{@"type":@(type)};
    } onSuccess:^(XMResult *  _Nullable responseObject) {
        HLHideLoading(controller.view);
        if ([responseObject code] == 200) {
            
            NSDictionary *mainPic = responseObject.data[@"main_pic"];
            if (mainPic) {
                double h = [mainPic[@"h"] doubleValue];
                double w = [mainPic[@"w"] doubleValue];
                mainScale = w/h;
            }else{
                mainScale = 0;
            }
            
            NSDictionary *subPic = responseObject.data[@"sub_pic"];
            if (subPic) {
                double h = [subPic[@"h"] doubleValue];
                double w = [subPic[@"w"] doubleValue];
                subScale = w/h;
            }else{
                subScale = 0;
            }
        }
        
        if(completion) completion(mainScale,subScale);
        
    } onFailure:^(NSError * _Nullable error) {
        HLHideLoading(controller.view);
        if(completion) completion(mainScale,subScale);
    }];
}

+ (double)defaultMainScaleWithType:(NSInteger)type{
    double result = 1;
    switch (type) {
        case 1:
            result = 5/4;
            break;
        case 2:
            result = 5/4;
            break;
        case 3:
            result = 4/3;
            break;
        case 4:
            result = 4/3;
            break;
        case 5:
        case 6:
            result = 1;
            break;
        default:
            result = 1;
            break;
    }
    return result;
}

+ (double)defaultSubScaleWithType:(NSInteger)type{
    double result = 1;
    switch (type) {
        case 1:
        case 2:
        case 3:
        case 4:
        case 5:
        case 6:
            result = 1;
            break;
        default:
            result = 1;
            break;
    }
    return result;
}


@end
