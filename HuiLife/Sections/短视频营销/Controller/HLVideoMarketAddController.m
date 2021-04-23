//
//  HLVideoMarketAddController.m
//  HuiLife
//
//  Created by 王策 on 2021/4/21.
//

#import "HLVideoMarketAddController.h"
#import <IQKeyboardManager/IQTextView.h>
#import "HLVideoProductSelectController.h"

@interface HLVideoMarketAddController ()

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UITextField *goodNameLab;
@property (nonatomic, strong) UITextView *titleInput;
@property (nonatomic, strong) UITextView *descInput;

@property (nonatomic, strong) UIImageView *videoImgV;
@property (nonatomic, strong) IQTextView *titleTextView;

@property (nonatomic, strong) IQTextView *descTextView;


@end

@implementation HLVideoMarketAddController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"创建短视频";
    
    [self creatSubViews];
}

#pragma mark - Method

/// 选择商品
- (void)selectGoods{
    HLVideoProductSelectController *selectGoods = [[HLVideoProductSelectController alloc] init];
    [self.navigationController pushViewController:selectGoods animated:YES];
}

#pragma mark - View

// 创建视图
- (void)creatSubViews{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, Height_NavBar, ScreenW, ScreenH - Height_NavBar)];
    [self.view addSubview:self.scrollView];
    self.scrollView.backgroundColor = UIColorFromRGB(0xF2F2F2);
    self.scrollView.contentSize = self.scrollView.bounds.size;
    AdjustsScrollViewInsetNever(self, self.scrollView);
    // 选择商品
    UIView *goodSelectView = [self creatGoodNameSelectView];
    [goodSelectView hl_addTarget:self action:@selector(selectGoods)];
    // 选择视频
    UIView *videoSelectView = [self createVideoSelectViewWithTopView:goodSelectView];
    // 底部输入框
    [self createDescInputViewWithTopView:videoSelectView];
}

// 底部视图
- (void)createDescInputViewWithTopView:(UIView *)topView{
    UIView *descInputView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(topView.frame) + FitPTScreen(1), ScreenW, FitPTScreen(120))];
    descInputView.backgroundColor = UIColor.whiteColor;
    [self.scrollView addSubview:descInputView];
    
    UILabel *tipLab = [[UILabel alloc] init];
    [descInputView addSubview:tipLab];
    tipLab.text = @"视频描述：";
    tipLab.textColor = UIColorFromRGB(0x666666);
    tipLab.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    [tipLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(FitPTScreen(16));
        make.left.equalTo(FitPTScreen(12));
    }];
    
    self.descTextView = [[IQTextView alloc] init];
    [descInputView addSubview:self.descTextView];
    self.descTextView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.descTextView.placeholder = @"请输入视频描述（最少5个字/最多50字以内）";
    self.descTextView.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    [self.descTextView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(8));
        make.top.equalTo(tipLab.bottom).offset(FitPTScreen(0));
        make.right.equalTo(FitPTScreen(-12));
        make.height.equalTo(FitPTScreen(80));
    }];
}

// 中间选择视频
- (UIView *)createVideoSelectViewWithTopView:(UIView *)topView{
    
    UIView *videoSelectView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(topView.frame) + FitPTScreen(10), ScreenW, FitPTScreen(158))];
    videoSelectView.backgroundColor = UIColor.whiteColor;
    [self.scrollView addSubview:videoSelectView];

    UILabel *starLab = [[UILabel alloc] init];
    [videoSelectView addSubview:starLab];
    starLab.text = @"*";
    starLab.textColor = UIColorFromRGB(0xEB1731);
    starLab.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    [starLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(FitPTScreen(15));
        make.left.equalTo(FitPTScreen(12));
    }];
    
    UILabel *tipLab = [[UILabel alloc] init];
    [videoSelectView addSubview:tipLab];
    tipLab.text = @"视频标题";
    tipLab.textColor = UIColorFromRGB(0x333333);
    tipLab.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    [tipLab makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(starLab);
        make.left.equalTo(starLab.right).offset(FitPTScreen(4));
    }];
    
    self.videoImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
    [videoSelectView addSubview:self.videoImgV];
    [self.videoImgV makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-15));
        make.width.equalTo(FitPTScreen(75));
        make.height.equalTo(FitPTScreen(100));
        make.top.equalTo(FitPTScreen(43));
    }];
    self.videoImgV.backgroundColor = UIColor.grayColor;

    self.titleTextView = [[IQTextView alloc] init];
    [videoSelectView addSubview:self.titleTextView];
    self.titleTextView.placeholder = @"请输入分享标题";
    self.titleTextView.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    [self.titleTextView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(8));
        make.bottom.equalTo(self.videoImgV);
        make.top.equalTo(self.videoImgV.top).offset(FitPTScreen(-4));
        make.right.equalTo(self.videoImgV.left).offset(FitPTScreen(-10));
    }];

    return videoSelectView;
}

// 顶部视图
- (UIView *)creatGoodNameSelectView{
    
    UIView *goodNameSelectView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, FitPTScreen(50))];
    goodNameSelectView.backgroundColor = UIColor.whiteColor;
    [self.scrollView addSubview:goodNameSelectView];
    
    UILabel *starLab = [[UILabel alloc] init];
    [goodNameSelectView addSubview:starLab];
    starLab.text = @"*";
    starLab.textColor = UIColorFromRGB(0xEB1731);
    starLab.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    [starLab makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(goodNameSelectView);
        make.left.equalTo(FitPTScreen(12));
    }];
    
    UILabel *tipLab = [[UILabel alloc] init];
    [goodNameSelectView addSubview:tipLab];
    tipLab.text = @"选择推广商品";
    tipLab.textColor = UIColorFromRGB(0x333333);
    tipLab.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    [tipLab makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(goodNameSelectView);
        make.left.equalTo(starLab.right).offset(FitPTScreen(4));
    }];
    
    UIImageView *arrowImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_right_darkGrey"]];
    [goodNameSelectView addSubview:arrowImgV];
    [arrowImgV makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-12));
        make.centerY.equalTo(goodNameSelectView);
        make.width.equalTo(FitPTScreen(6));
        make.height.equalTo(FitPTScreen(11));
    }];
    
    _goodNameLab = [[UITextField alloc] init];
    [goodNameSelectView addSubview:_goodNameLab];
    _goodNameLab.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    _goodNameLab.textColor = UIColorFromRGB(0x333333);
    _goodNameLab.placeholder = @"请选择推送商品(秒杀/外卖)";
    _goodNameLab.enabled = NO;
    _goodNameLab.textAlignment = NSTextAlignmentRight;
    [_goodNameLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(125));
        make.right.equalTo(arrowImgV.left).offset(FitPTScreen(-5));
        make.top.bottom.equalTo(0);
    }];
    
    return goodNameSelectView;
}

@end
