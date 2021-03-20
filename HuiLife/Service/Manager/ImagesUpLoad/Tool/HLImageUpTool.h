//
//  HLImageUpTool.h
//  HuiLife
//
//  Created by 王策 on 2019/8/13.
//

#import <Foundation/Foundation.h>
#import "HLBaseUploadModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HLImageUpTool : NSObject

- (void)asyncConcurrentGroupUploadArray:(NSArray<HLBaseUploadModel *> *)modelArray uploading:(void(^)(void))uploading completion:(void (^)(void))completion;

- (void)addUploadModels:(NSArray *)modelArray;

@end

NS_ASSUME_NONNULL_END
