//
//  HLStoreModel.h
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/10/19.
//

#import <Foundation/Foundation.h>

@interface HLStoreModel : NSObject

@property(copy,nonatomic)NSString * storeID;

@property(copy,nonatomic)NSString * address;

@property(copy,nonatomic)NSString * class_id;

@property(copy,nonatomic)NSString * classname;

@property(copy,nonatomic)NSString * has_user;

@property(copy,nonatomic)NSString * is_general_store;

@property(copy,nonatomic)NSString * is_show;

@property(copy,nonatomic)NSString * name;

@property(copy,nonatomic)NSString * tel;

//----------------显示在界面上的-----------------------------
@property (copy,nonatomic)NSString * nameText;

@property (copy,nonatomic)NSString * classnameText;

@property (assign,nonatomic)CGFloat classnameTextW;

@end

