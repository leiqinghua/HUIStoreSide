//
//  ALiConfig.h
//  ALiImagePicker
//
//  Created by LeeWong on 2016/10/28.
//  Copyright © 2016年 LeeWong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, EALiPickerResourceType){
    EALiPickerResourceTypeUnknown = 0,
    EALiPickerResourceTypeImage   = 1,
    EALiPickerResourceTypeVideo   = 2,
    EALiPickerResourceTypeAudio   = 3,
};

typedef NS_ENUM(NSInteger, EALiImageContentMode) {
    EALiImageContentModeAspectFit = 0,
    EALiImageContentModeAspectFill = 1,
    EALiImageContentModeDefault = PHImageContentModeAspectFit
};

static const NSString *kPHImage = @"PHImage";
static const NSString *kPHTitle = @"PHTitle";
static const NSString *kPHCount = @"PHCount";

#define WEAKSELF(weakSelf)  __weak __typeof(&*self)weakSelf = self;
#define SCREEN_W [UIScreen mainScreen].bounds.size.width
#define SCREEN_H [UIScreen mainScreen].bounds.size.height

@interface ALiConfig : NSObject

@end
