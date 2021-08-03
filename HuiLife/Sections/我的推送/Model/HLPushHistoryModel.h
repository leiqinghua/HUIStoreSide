//
//  HLPushHistoryModel.h
//  HuiLife
//
//  Created by 王策 on 2021/4/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HLPushHistoryModel : NSObject

@property (nonatomic, assign) NSInteger number;

@property (nonatomic, assign) NSInteger cumulative;

@property (nonatomic, copy) NSArray *notes;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *image;

@property (nonatomic, copy) NSString *describe;

@property (nonatomic, copy) NSString *date;

@property (nonatomic, copy) NSString *range;

@property (nonatomic, assign) NSInteger total;

@property (nonatomic, copy) NSArray *times;

@property (nonatomic, copy) NSArray *push_history;

@end

NS_ASSUME_NONNULL_END

//data =     {
//    cumulative = 0;
//    date = "";
//    describe = "正品，质量好，价格低，性比价高，物美价廉，物有所值，朋友看了都说好。客服服务热情都到。物流很给力";
//    image = "http://aimg8.oss-cn-shanghai.aliyuncs.com/push/47979_16173651581291.jpg";
//    notes =         (
//    );
//    number = 1;
//    "push_history" =         (
//    );
//    range = "本店范围";
//    title = "好吃的嗨吃家";
//    total = 33;
//};

//times =         (
//                {
//        name = "立即推送";
//        today = "2021-04-26";
//        type = 1;
//        values =                 (
//            "立即推送"
//        );
//    },
//                {
//        name = "今天(上午)";
//        today = "2021-04-26";
//        type = 2;
//        values =                 (
//            "08:00",
//            "08:10",
//            "08:20",
//            "08:30",
//            "08:40",
//            "08:50",
//            "09:00",
//            "09:10",
//            "09:20",
//            "09:30",
//            "09:40",
//            "09:50",
//            "10:00",
//            "10:10",
//            "10:20",
//            "10:30",
//            "10:40",
//            "10:50",
//            "11:00",
//            "11:10",
//            "11:20",
//            "11:30",
//            "11:40",
//            "11:50",
//            "12:00"
//        );
//    },
//                {
//        name = "今天(下午)";
//        today = "2021-04-26";
//        type = 3;
//        values =                 (
//            "13:00",
//            "13:10",
//            "13:20",
//            "13:30",
//            "13:40",
//            "13:50",
//            "14:00",
//            "14:10",
//            "14:20",
//            "14:30",
//            "14:40",
//            "14:50",
//            "15:00",
//            "15:10",
//            "15:20",
//            "15:30",
//            "15:40",
//            "15:50",
//            "16:00",
//            "16:10",
//            "16:20",
//            "16:30",
//            "16:40",
//            "16:50",
//            "17:00",
//            "17:10",
//            "17:20",
//            "17:30",
//            "17:40",
//            "17:50",
//            "18:00"
//        );
//    }
//);
