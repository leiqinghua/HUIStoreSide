//
//  main.m
//  HuiLife
//
//  Created by 雷清华 on 2018/7/10.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
        @try {
            @autoreleasepool
            {
                return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
            }
        }
        @catch (NSException* exception)
        {
            HLLog(@"Exception=%@\nStack Trace:%@", exception, [exception callStackSymbols]);
        }
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
