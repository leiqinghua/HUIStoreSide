//
//  HLSetVideoTableCell.m
//  HuiLife
//
//  Created by 雷清华 on 2019/10/10.
//

#import "HLSetVideoTableCell.h"


@interface HLSetVideoTableCell ()

@property(nonatomic,strong)UILabel * titleLb;

@property(nonatomic,strong)UIImageView * imgV;

@property(nonatomic,strong)UIView * bagView;

//
@property(nonatomic,strong)UIImageView * videoBg;

//
@property(nonatomic,strong)UIImageView * videoTipImV;

@property(nonatomic,strong)UILabel * timeLb;

@property(nonatomic,strong)UILabel * progressLb;

@end


@implementation HLSetVideoTableCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initView];
    }
    return self;
}

-(void)initView{
    
    self.backgroundColor = UIColor.clearColor;
    _bagView = [[UIView alloc]init];
    _bagView.backgroundColor = UIColor.whiteColor;
    _bagView.layer.shadowColor = [UIColor colorWithRed:223/255.0 green:223/255.0 blue:223/255.0 alpha:0.42].CGColor;
    _bagView.layer.shadowOffset = CGSizeMake(0,3);
    _bagView.layer.shadowOpacity = 1;
    _bagView.layer.shadowRadius = FitPTScreen(22);
    _bagView.layer.cornerRadius = FitPTScreen(7);
    _bagView.layer.masksToBounds = false;
    [self.contentView addSubview:_bagView];
    [_bagView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(FitPTScreen(10), FitPTScreen(13), FitPTScreen(5), FitPTScreen(13)));
    }];
    
    _titleLb = [[UILabel alloc]init];
    _titleLb.textColor = UIColorFromRGB(0x333333);
    _titleLb.font = [UIFont systemFontOfSize:FitPTScreen(15)];
    _titleLb.text = @"店铺视频";
    [_bagView addSubview:_titleLb];
    [_titleLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(14));
        make.centerY.equalTo(self.bagView);
    }];
    
    _imgV = [[UIImageView alloc]init];
    _imgV.layer.cornerRadius = 4;
    _imgV.contentMode = UIViewContentModeScaleAspectFill;
    _imgV.layer.masksToBounds = YES;
    [_bagView addSubview:_imgV];
    [_imgV makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bagView);
        make.right.equalTo(FitPTScreen(-31));
        make.width.height.equalTo(FitPTScreen(91));
    }];
    
    UIImageView * arrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow_right_grey"]];
    arrow.layer.cornerRadius = 4;
    [_bagView addSubview:arrow];
    [arrow makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bagView);
        make.right.equalTo(FitPTScreen(-13));
    }];
    
    _videoBg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"video_bag"]];
    [_imgV addSubview:_videoBg];
    [_videoBg makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.imgV);
    }];
    
    _videoTipImV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"little_video"]];
    [_imgV addSubview:_videoTipImV];
    [_videoTipImV makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.videoBg);
        make.left.equalTo(FitPTScreen(9));
    }];
    
    _timeLb = [[UILabel alloc]init];
    _timeLb.textColor = UIColorFromRGB(0xFFFFFF);
    _timeLb.font = [UIFont systemFontOfSize:FitPTScreen(10)];
    [_videoBg addSubview:_timeLb];
    [_timeLb makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-9));
        make.centerY.equalTo(self.videoBg);
    }];
    
    _progressLb = [[UILabel alloc]init];
    _progressLb.textAlignment = NSTextAlignmentCenter;
    _progressLb.textColor = UIColorFromRGB(0xFF9F16);
    _progressLb.font = [UIFont systemFontOfSize:FitPTScreen(10)];
    [_imgV addSubview:_progressLb];
    [_progressLb makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self.imgV);
    }];
}

-(void)setMainModel:(HLSetModel *)mainModel{
    _mainModel = mainModel;
    [_imgV sd_setImageWithURL:[NSURL URLWithString:mainModel.video_pic] placeholderImage:[UIImage imageNamed:@"add_video"]];
    _timeLb.text = [HLTools convertStrToTime:mainModel.video_duration];
    if (mainModel.state.length) {
        _progressLb.text = mainModel.state;
    }else{
        self.progress = mainModel.progress;
    }
}

-(void)setProgress:(CGFloat)progress{
    _progress = progress;
    if (progress == 0 || progress == 1) {
        _progressLb.text = @"";
        return;
    }
    _progressLb.text = [NSString stringWithFormat:@"%.1lf%%",_progress * 100];
    
}


//-(void)setState:(NSString *)state{
//    _state = state;
//    _progressLb.text = state;
//}
@end
