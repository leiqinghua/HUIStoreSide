//
//  HLVideoMarketPlayController.m
//  HuiLife
//
//  Created by 王策 on 2021/4/25.
//

#import "HLVideoMarketPlayController.h"

@interface HLVideoMarketPlayController ()

@property (nonatomic, strong) UIButton *centerPlayBtn;

@end

@implementation HLVideoMarketPlayController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 底部数据视图
    [self creatSubViews];
    
    // 中间播放按钮
    self.centerPlayBtn = [[UIButton alloc] init];
    [self.view addSubview:self.centerPlayBtn];
    [self.centerPlayBtn setBackgroundImage:[UIImage imageNamed:@"video_button_play"] forState:UIControlStateNormal];
    [self.centerPlayBtn setBackgroundImage:[UIImage imageNamed:@"video_button_pause"] forState:UIControlStateSelected];
    [self.centerPlayBtn makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(FitPTScreen(40));
        make.center.equalTo(self.view);
    }];
    self.centerPlayBtn.hidden = YES;
    [self.centerPlayBtn addTarget:self action:@selector(centerPlayBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    // 回调控制
    self.controlView.portraitControlView.playOrPauseBtn.hidden = YES;
    self.controlView.portraitControlView.fullScreenBtn.hidden = YES;
    self.controlView.portraitControlView.slider.minimumTrackTintColor = UIColorFromRGB(0xFF9900);
    self.controlView.bottomPgrogress.minimumTrackTintColor = UIColorFromRGB(0xFF9900);
    weakify(self);
    self.controlView.controlViewAppearedCallback = ^(BOOL appeared) {
        weak_self.centerPlayBtn.hidden = !appeared;
    };
    self.player.playerPlayStateChanged = ^(id<ZFPlayerMediaPlayback>  _Nonnull asset, ZFPlayerPlaybackState playState) {
        if (playState == ZFPlayerPlayStatePlaying) {
            weak_self.centerPlayBtn.selected = YES;
        }else{
            weak_self.centerPlayBtn.selected = NO;
        }
    };
}

- (void)centerPlayBtnClick:(UIButton *)button{
    button.selected = !button.selected;
    if (button.selected) {
        [self.player.currentPlayerManager play];
    }else{
        [self.player.currentPlayerManager pause];
    }
}

- (void)creatSubViews{
    
    UILabel *descLab = [[UILabel alloc] init];
    [self.view addSubview:descLab];
    descLab.font = [UIFont systemFontOfSize:FitPTScreen(12)];
    descLab.textColor = UIColorFromRGB(0xFFFFFF);
    descLab.numberOfLines = 3;
    [descLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(20));
        make.right.equalTo(FitPTScreen(-50));
        make.bottom.equalTo(FitPTScreen(-33) - Height_Bottom_Margn);
    }];
    
    UILabel *titleLab = [[UILabel alloc] init];
    [self.view addSubview:titleLab];
    titleLab.font = [UIFont boldSystemFontOfSize:FitPTScreen(14)];
    titleLab.textColor = UIColorFromRGB(0xFFFFFF);
    titleLab.numberOfLines = 2;
    [titleLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(descLab);
        make.bottom.equalTo(descLab.top).offset(FitPTScreen(-12));
    }];
    
    UIView *goodsView = [[UIView alloc] init];
    [self.view addSubview:goodsView];
    goodsView.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.8];
    goodsView.layer.cornerRadius = FitPTScreen(12.5);
    goodsView.layer.masksToBounds = YES;
    [goodsView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLab);
        make.bottom.equalTo(titleLab.top).offset(FitPTScreen(-16));
        make.height.equalTo(FitPTScreen(25));
        make.right.lessThanOrEqualTo(self.view.right);
    }];
    
    UIImageView *goodsImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"video_good_tip"]];
    [goodsView addSubview:goodsImgV];
    [goodsImgV makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(goodsView);
        make.left.equalTo(FitPTScreen(10.5));
        make.width.equalTo(FitPTScreen(13));
        make.height.equalTo(FitPTScreen(14));
    }];
    
    UILabel *goodNameLab = [[UILabel alloc] init];
    [goodsView addSubview:goodNameLab];
    goodNameLab.font = [UIFont systemFontOfSize:FitPTScreen(12)];
    goodNameLab.textColor = UIColorFromRGB(0x666666);
    [goodNameLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(goodsImgV.right).offset(FitPTScreen(4.5));
        make.right.equalTo(FitPTScreen(-11.5));
        make.centerY.equalTo(goodsView);
    }];
    
    descLab.text = self.marketModel.content;
    titleLab.text = self.marketModel.title;
    goodNameLab.text = self.marketModel.name;
}

@end
