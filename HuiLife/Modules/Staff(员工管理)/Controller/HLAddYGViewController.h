//
//  HLAddYGViewController.h
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/7/20.
//

#import <UIKit/UIKit.h>
#import "HLStaffModel.h"

@interface HLAddYGViewController : HLBaseViewController
//是否是添加页面（管理员添加页面，店长添加页面）
@property(assign,nonatomic)BOOL isAdd;

/*
 id = 48717;
 "is_dianzhang" = 1;
 mobile = "";
 name = xiaohua5;
 store = "\U5929\U4eae\U5927\U9e21\U6392\U5858\U6cbd\U5e97";
 "store_id" = 18940;
 "user_name" = xiaohua5;
 */
@property(strong,nonatomic)NSDictionary * userInfo;

@property(strong,nonatomic)HLStaffModel * staffModel;

@end
