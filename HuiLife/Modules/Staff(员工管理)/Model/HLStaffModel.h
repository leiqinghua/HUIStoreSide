//
//  HLStaffModel.h
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/10/18.
//

#import <Foundation/Foundation.h>

@interface HLStaffModel : NSObject

@property(copy,nonatomic)NSString * staffID;

@property(copy,nonatomic)NSString * is_dianzhang;

@property(copy,nonatomic)NSString * mobile;

@property(copy,nonatomic)NSString * name;

@property(copy,nonatomic)NSString * store;

@property(copy,nonatomic)NSString * store_id;

@property(copy,nonatomic)NSString * user_name;

//----------------显示的text-------------
//要显示的名字
@property (copy,nonatomic) NSString * nameText;

@end


