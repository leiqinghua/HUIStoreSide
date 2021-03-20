//
//  HLAlbumViewCell.m
//  HuiLife
//
//  Created by 王策 on 2019/12/10.
//

#import "HLAlbumViewCell.h"
#import "HLImagePickerService.h"

@interface HLAlbumViewCell ()

@property (nonatomic, strong) UIImageView *imageV;
@property (nonatomic, strong) UILabel *nameLab;
@property (nonatomic, strong) UILabel *countLab;


@end

@implementation HLAlbumViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [self initSubUI];
    }
    return self;
}

- (void)initSubUI{
    
    _imageV = [[UIImageView alloc] init];
    [self.contentView addSubview:_imageV];
    _imageV.clipsToBounds = YES;
    _imageV.contentMode = UIViewContentModeScaleAspectFill;
    [_imageV makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(12.5));
        make.width.height.equalTo(FitPTScreen(63.5));
        make.centerY.equalTo(self.contentView);
    }];
    
    _nameLab = [[UILabel alloc] init];
    [self.contentView addSubview:_nameLab];
    [_nameLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_imageV.right).offset(FitPTScreen(10));
        make.centerY.equalTo(self.contentView);
    }];
}

- (void)setAlbum:(HLAlbum *)album{
    _album = album;
    
    NSMutableAttributedString *nameString = [[NSMutableAttributedString alloc] initWithString:album.name attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:UIColorFromRGB(0x222222)}];
    NSAttributedString *countString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"  (%zd)",album.count] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:UIColorFromRGB(0x777777)}];
    [nameString appendAttributedString:countString];
    self.nameLab.attributedText = nameString;
    
    [HLImagePickerService getPostImageWithAlbumModel:album completion:^(UIImage * image) {
        self.imageV.image = image;
    }];
}

@end
