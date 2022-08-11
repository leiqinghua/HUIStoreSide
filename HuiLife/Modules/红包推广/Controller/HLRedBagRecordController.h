//
//  HLRedBagRecordController.h
//  HuiLife
//
//  Created by 雷清华 on 2020/11/19.
//

#import "HLBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
@class HLRedBagRecordTableCell;
@class HLRedBagRecordInfo;
@interface HLRedBagRecordController : HLBaseViewController

@property(nonatomic, assign) BOOL hideUser;
//0-领取记录，1-充值记录，2-退款记录
@property(nonatomic, assign) NSInteger type;

- (void)startLoadListWithId:(NSString *)Id;

@end

@interface HLRedBagRecordTableCell : UITableViewCell
@property(nonatomic, assign) BOOL hideUser;
@property(nonatomic, strong) HLRedBagRecordInfo *recordInfo;
@end

NS_ASSUME_NONNULL_END
