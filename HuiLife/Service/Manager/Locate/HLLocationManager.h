//
//  HLLocationManager.h
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/1/27.
//

#import <Foundation/Foundation.h>
#import <BMKLocationkit/BMKLocationComponent.h>


typedef void(^LocateBlock)(BMKLocation* location);

@interface HLLocationManager : NSObject

+ (instancetype)shared;

- (void)startLocationWithCallBack:(LocateBlock)callBack;

@end

