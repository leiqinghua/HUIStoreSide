//
//  HLCustomerController.h
//  HuiLife
//
//  Created by 雷清华 on 2019/8/27.
//客服

#import "HLBaseViewController.h"


@class HLCustomerModel;
@class HLCustomerTableCell;

@interface HLCustomerController : HLBaseViewController

- (void)loadCustomData;

@end

@interface HLCustomerTableCell: UITableViewCell

@property(nonatomic,strong)HLCustomerModel * model;

@end



@interface HLCustomerModel : NSObject

@property(nonatomic,copy)NSString * leftPic;

@property(nonatomic,copy)NSString * title;

@property(nonatomic,copy)NSString * text;

@property(nonatomic,copy)NSString * rightPic;

@property(nonatomic,assign)BOOL phone;

@property(nonatomic,strong)NSAttributedString * titleAttr;

@end
