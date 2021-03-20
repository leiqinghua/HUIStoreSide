//
//  HLAreaCache.h
//  HuiLife
//
//  Created by HuiLife on 2018/9/20.
//

#import <Foundation/Foundation.h>


typedef void(^HLAreaCacheCallBack)(NSArray *areaArr);

@interface HLAreaCache : NSObject

+ (void)loadAreaDataWithCallBack:(HLAreaCacheCallBack)callBack;

@end
