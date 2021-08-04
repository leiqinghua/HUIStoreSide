//
//  HLBuyCardViewController.h
//  HuiLife
//
//  Created by 王策 on 2021/3/20.
//

#import "HLBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface HLBuyCardViewController : HLBaseViewController

@property (nonatomic, copy) void(^buySuccessBlock)(void);

@end


///////// 页面使用Model /////////
@class HLBuyCardVCStore;
@class HLBuyCardVCCard;
@interface HLBuyCardVCModel : NSObject

@property (nonatomic, strong) HLBuyCardVCStore *store;
@property (nonatomic, strong) HLBuyCardVCCard *card;

@end

@interface HLBuyCardVCStore : NSObject

@property (nonatomic, copy) NSString *classId;
@property (nonatomic, copy) NSString *className;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *storeAddress;
@property (nonatomic, copy) NSString *storeId;
@property (nonatomic, copy) NSString *storeName;
@property (nonatomic, copy) NSString *storePic;

@end

@interface HLBuyCardVCCard : NSObject

@property (nonatomic, copy) NSString *gife;
@property (nonatomic, copy) NSString *minNum;
@property (nonatomic, copy) NSString *multiple;
@property (nonatomic, copy) NSArray *package;
@property (nonatomic, copy) NSString *price;

@end

NS_ASSUME_NONNULL_END
