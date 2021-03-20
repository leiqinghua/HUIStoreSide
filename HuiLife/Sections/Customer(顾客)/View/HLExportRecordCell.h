//
//  HLExportRecordCell.h
//  HuiLife
//
//  Created by 雷清华 on 2020/10/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol HLExportRecordCellDelegate ;
@class HLExportRecordInfo;

@interface HLExportRecordCell : UITableViewCell
//索引
@property(nonatomic, assign) NSInteger index;

//@property(nonatomic, strong) HLExportRecordInfo *info;

@property(nonatomic, strong) id<HLExportRecordCellDelegate>delegate;

- (void)configBackgroundColor:(NSString *)color ;

- (void)configNum:(NSInteger)num name:(NSString *)name time:(NSString *)time done:(BOOL)done;

@end

@protocol HLExportRecordCellDelegate <NSObject>

//- (void)recordCell:(HLExportRecordCell *)cell downWithInfo:(HLExportRecordInfo *)info;

- (void)recordCell:(HLExportRecordCell *)cell index:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END
