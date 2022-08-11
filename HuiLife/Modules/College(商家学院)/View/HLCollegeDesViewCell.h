//
//  HLCollegeDesViewCell.h
//  HuiLife
//
//  Created by 雷清华 on 2019/8/28.
//

#import <UIKit/UIKit.h>
#import "HLInfoModel.h"

@interface HLCollegeDesModel : HLInfoModel

@property(nonatomic,assign)NSInteger maxNum;

@property(nonatomic,assign)BOOL showNumLb;

@end


@interface HLCollegeDesViewCell : UITableViewCell

@property(nonatomic,strong)HLInfoModel * infoModel;

@end

