//
//  HLOptionDescTableCell.m
//  HuiLife
//
//  Created by 雷清华 on 2019/10/16.
//

#import "HLOptionDescTableCell.h"

@interface HLOptionDescTableCell ()

@property(nonatomic, strong) UIImageView *headView;

@property(nonatomic, strong) UIImageView *bagView;

@property(nonatomic, strong) UIImageView *videoView;

@property(nonatomic, strong) UILabel *videoTimeLb;

@property(nonatomic, strong) UILabel *timeLb;

@property(nonatomic, strong) UILabel *titleLb;

@property(nonatomic, strong) UILabel *descLb;

@property(nonatomic, strong) UIImageView *sightView;

@property(nonatomic, strong) UILabel *numLb;

@end

@implementation HLOptionDescTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initSubView];
    }
    return self;
}

- (void)initSubView {
    _headView = [[UIImageView alloc]init];
    [self.contentView addSubview:_headView];
    [_headView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(FitPTScreen(17));
        make.left.equalTo(FitPTScreen(13));
        make.width.height.equalTo(FitPTScreen(82));
    }];
    
    _bagView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"video_bag"]];
    [_headView addSubview:_bagView];
    [_bagView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.headView);
    }];
    
    _videoView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"little_video"]];
    _videoView.contentMode = UIViewContentModeScaleAspectFit;
    [_headView addSubview:_videoView];
    [_videoView makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bagView);
        make.left.equalTo(FitPTScreen(6));
    }];
    
    _videoTimeLb = [[UILabel alloc]init];
    _videoTimeLb.textColor = UIColor.whiteColor;
    _videoTimeLb.font = [UIFont systemFontOfSize:FitPTScreen(10)];
    [_headView addSubview:_videoTimeLb];
    [_videoTimeLb makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-6));
        make.centerY.equalTo(self.bagView);
    }];
    
    _titleLb = [[UILabel alloc]init];
    _titleLb.text = @"";
    _titleLb.textColor = UIColorFromRGB(0x333333);
    _titleLb.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    [self.contentView addSubview:_titleLb];
    [_titleLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headView.right).offset(FitPTScreen(16));
        make.top.equalTo(FitPTScreen(20));
    }];
    
    _descLb = [[UILabel alloc]init];
    _descLb.text = @"";
    _descLb.textColor = UIColorFromRGB(0x888888);
    _descLb.font = [UIFont systemFontOfSize:FitPTScreen(12)];
    _descLb.numberOfLines = 2;
    [self.contentView addSubview:_descLb];
    [_descLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLb);
        make.top.equalTo(self.titleLb.bottom).offset(FitPTScreen(8));
        make.width.lessThanOrEqualTo(FitPTScreen(251));
    }];
    
    _sightView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sight"]];
    [self.contentView addSubview:_sightView];
    [_sightView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headView.right).offset(FitPTScreen(16));
        make.bottom.equalTo(FitPTScreen(-16));
    }];
    
    _numLb = [[UILabel alloc]init];
    _numLb.text = @"";
    _numLb.textColor = UIColorFromRGB(0xB0B0B0);
    _numLb.font = [UIFont systemFontOfSize:FitPTScreen(11)];
    [self.contentView addSubview:_numLb];
    [_numLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.sightView.right).offset(FitPTScreen(10));
        make.centerY.equalTo(self.sightView);
    }];
    
    _timeLb = [[UILabel alloc]init];
    _timeLb.text = @"";
    _timeLb.textColor = UIColorFromRGB(0xB0B0B0);
    _timeLb.font = [UIFont systemFontOfSize:FitPTScreen(11)];
    [self.contentView addSubview:_timeLb];
    [_timeLb makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-13));
        make.bottom.equalTo(FitPTScreen(-16));
    }];
    
}

- (void)setModel:(HLOptionModel *)model {
    _model = model;
    _titleLb.text = model.title;
    _descLb.text = model.content;
    _numLb.text = [NSString stringWithFormat:@"%ld",model.num];
    _timeLb.text = model.input_time;
    [_headView sd_setImageWithURL:[NSURL URLWithString:model.pic] placeholderImage:[UIImage imageNamed:@"logo_default"]];
    _videoTimeLb.text = model.duration;
    
}
@end
