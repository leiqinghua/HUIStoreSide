//
//  HLImagePickerConfig.m
//  HuiLife
//
//  Created by 王策 on 2019/12/10.
//

#import "HLImagePickerConfig.h"

@implementation HLImagePickerConfig

- (BOOL)needResize{
    if (_mustResize) {
        return YES;
    }
    return _needResize;
}

@end
