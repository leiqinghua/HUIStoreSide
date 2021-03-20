//
//  HLSetVideoTableCell.h
//  HuiLife
//
//  Created by 雷清华 on 2019/10/10.
//

#import <UIKit/UIKit.h>
#import "HLSetModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HLSetVideoTableCell : UITableViewCell

@property(nonatomic,strong)HLSetModel * mainModel;

@property(nonatomic,assign)CGFloat progress;

//@property(nonatomic,copy)NSString * timeStr;
//
//@property(nonatomic,copy)NSString * pic;

@property(nonatomic,copy)NSString * state;

@end

NS_ASSUME_NONNULL_END
