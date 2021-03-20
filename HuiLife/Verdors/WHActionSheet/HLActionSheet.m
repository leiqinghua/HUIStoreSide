//
//  HLActionSheet.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/1/26.
//

#import "HLActionSheet.h"

@implementation HLActionSheet
/// 个人信息编辑时样式
+ (WHActionSheet *)showActionSheetWithDataSource:(NSArray *)dataSource delegate:(id)delegate{
    // 初始化 默认样式
    WHActionSheet *actionSheet = [[WHActionSheet alloc] initWithTitle:@"" sheetTitles:dataSource cancleBtnTitle:@"取消" sheetStyle:(WHActionSheetDefault) delegate:delegate];
    actionSheet.isCorner = NO;
    actionSheet.subtitlebgColor = [UIColor whiteColor];
    actionSheet.subtitleColor = UIColorFromRGB(0x333333);
    actionSheet.canclebgColor = [UIColor whiteColor];
    actionSheet.cancleHeight = FitPTScreen(45);
    actionSheet.sheetHeight = FitPTScreen(45);
    actionSheet.cancelFont = [UIFont systemFontOfSize:FitPTScreen(13)];
    actionSheet.subtitleFont = [UIFont systemFontOfSize:FitPTScreen(13)];
    [actionSheet show];
    return actionSheet;
}

@end
