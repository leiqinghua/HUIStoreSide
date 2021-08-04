//
//  HLMutablePickerController.h
//  HuiLife
//
//  Created by 雷清华 on 2019/11/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^HLMutablePickerBlock)(NSString *bigName,NSString *subName,NSString *bigId,NSString *subId);

@class HLMutablePickerModel;
@interface HLMutablePickerController : UIViewController

@property(nonatomic, copy)HLMutablePickerBlock pickerBlock;

- (void)configDataSource:(NSArray<HLMutablePickerModel *> *)pickerDatasource bigId:(NSString *)bigId subId:(NSString *)subId;

@end


@interface HLMutablePickerModel : NSObject

@property(nonatomic, copy) NSString *Id;

@property(nonatomic, copy) NSString *name;

@property(nonatomic, strong) NSArray *sub;

@end


NS_ASSUME_NONNULL_END
