//
//  HLSetModel.h
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/8/3.
//

#import <Foundation/Foundation.h>
#import "HLBaseInputModel.h"

@interface HLSetModel : NSObject
@property(nonatomic,copy) NSString *id;

@property(nonatomic,copy) NSString *title;
// 门店主图
@property(nonatomic,copy) NSString *pic;
// 门店相册图片数量
@property(nonatomic,assign) NSInteger imageCnt;

@property(nonatomic,strong) NSArray <HLBaseInputModel *> *inputs;

@property(nonatomic,assign) CGFloat inputViewH;

@property(nonatomic,assign) CGFloat inputCellH;

// 视频地址
@property(nonatomic,copy) NSString * video_url;
// 缩略图地址
@property(nonatomic,copy) NSString * video_pic;
// 视频时长
@property(nonatomic,copy) NSString * video_duration;

// 状态（重新上传）
@property(nonatomic,copy) NSString *state;
@property(nonatomic,assign) CGFloat progress;
@property(nonatomic,assign) NSInteger videoState;
@property(nonatomic,assign) NSInteger picState;

@end

