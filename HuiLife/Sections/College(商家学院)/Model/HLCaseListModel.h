//
//  HLCaseListModel.h
//  HuiLife
//
//  Created by 王策 on 2019/8/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HLCaseListModel : NSObject

@property (nonatomic, assign) NSInteger second;
@property (nonatomic, copy) NSString *video;
@property (nonatomic, copy) NSString *cover_image;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *Id;


//id    视频ID
//title    视频标题
//cover_image    封面图
//video    视频地址
//second    视频长度（秒）

@end

NS_ASSUME_NONNULL_END
