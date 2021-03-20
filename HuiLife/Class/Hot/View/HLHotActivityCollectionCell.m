//
//  HLHotActivityCollectionCell.m
//  HuiLife
//
//  Created by 雷清华 on 2020/2/19.
//

#import "HLHotActivityCollectionCell.h"

@interface HLHotActivityCollectionCell ()

@property(nonatomic, strong) UIView *bagView;

@property(nonatomic, strong) UIImageView *headView;

@property(nonatomic, strong) UILabel *actiTipLb;

@property(nonatomic, strong) UILabel *storeNumLb;

@property(nonatomic, strong) UIImageView *storeBgView;

@property(nonatomic, strong) UILabel *actiNameLb;

//@property(nonatomic, strong) UILabel *peopleNumLb;

@property(nonatomic, strong) UIButton *createBtn;

@property(nonatomic, strong) NSArray *tags;

@property(nonatomic, strong) NSMutableArray *tagLbs;

@property(nonatomic, strong) UIScrollView *tagScroll;

@end

@implementation HLHotActivityCollectionCell

- (void)initSubView {
    [super initSubView];
    
    UIView *bagView = [[UIView alloc]init];
    bagView.backgroundColor = UIColor.whiteColor;
    bagView.layer.cornerRadius = FitPTScreen(6);
    bagView.layer.masksToBounds = YES;
    [self.contentView addSubview:bagView];
    [bagView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, FitPTScreen(6), FitPTScreen(10), FitPTScreen(6)));
    }];
    _bagView = bagView;
    
    _headView = [[UIImageView alloc]init];
    _headView.image = [UIImage imageNamed:@"hot_head"];
    [bagView addSubview:_headView];
    [_headView makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(bagView);
        make.height.equalTo(FitPTScreen(170));
    }];
    
    _actiTipLb = [UILabel hl_regularWithColor:@"#FFFFFF" font:11];
    _actiTipLb.backgroundColor = UIColorFromRGB(0xFF812A);
    _actiTipLb.textAlignment = NSTextAlignmentCenter;
    [bagView addSubview:_actiTipLb];
    [_actiTipLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bagView);
        make.top.equalTo(FitPTScreen(5));
        make.width.equalTo(FitPTScreen(90));
        make.height.equalTo(FitPTScreen(21));
    }];
    
    _storeBgView = [[UIImageView alloc]init];
    _storeBgView.image = [UIImage imageNamed:@"hot_tip_bg"];
    [bagView addSubview:_storeBgView];
    [_storeBgView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.actiTipLb.right);
        make.centerY.equalTo(self.actiTipLb);
        make.width.equalTo(FitPTScreen(79));
        make.height.equalTo(FitPTScreen(21));
    }];
    
    _storeNumLb = [UILabel hl_regularWithColor:@"#FFFFFF" font:11];
    [_storeBgView addSubview:_storeNumLb];
    [_storeNumLb makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.centerX.equalTo(self.storeBgView);
    }];
    

    _actiNameLb = [UILabel hl_regularWithColor:@"#222222" font:14];
    _actiNameLb.numberOfLines = 2;
    [bagView addSubview:_actiNameLb];
    [_actiNameLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(13));
        make.top.equalTo(self.headView.bottom).offset(FitPTScreen(15));
        make.width.lessThanOrEqualTo(FitPTScreen(142));
    }];
    
    _createBtn = [UIButton hl_regularWithTitle:@"创建同款活动" titleColor:@"#222222" font:14 image:@""];
    _createBtn.layer.cornerRadius = FitPTScreen(15);
    _createBtn.layer.borderColor = UIColorFromRGB(0x252525).CGColor;
    _createBtn.layer.borderWidth = 0.8;
    _createBtn.userInteractionEnabled = NO;
    [bagView addSubview:_createBtn];
    [_createBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bagView);
        make.bottom.equalTo(FitPTScreen(-14));
        make.width.equalTo(FitPTScreen(150));
        make.height.equalTo(FitPTScreen(30));
    }];
    
    _tagScroll = [[UIScrollView alloc]init];
    _tagScroll.showsHorizontalScrollIndicator = NO;
    [self.bagView addSubview:_tagScroll];
    [_tagScroll makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(10));
        make.right.equalTo(FitPTScreen(-10));
        make.bottom.equalTo(self.createBtn.top).offset(-FitPTScreen(15));
        make.height.equalTo(FitPTScreen(19));
    }];
    
//    self.tags = @[@"火锅",@"湘菜"];
}

- (void)setTags:(NSArray *)tags {
    
    if (!_tagLbs.count) {
        _tagLbs = [NSMutableArray array];
    }
    
    if (tags.count == _tags.count) {
        _tags = tags;
        [_tags enumerateObjectsUsingBlock:^(NSString *  _Nonnull tag, NSUInteger idx, BOOL * _Nonnull stop) {
            UILabel *lable = self.tagLbs[idx];
            lable.text = tag;
        }];
        return;
    }
    
    _tags = tags;
    [self.tagLbs enumerateObjectsUsingBlock:^(UILabel *  _Nonnull lable, NSUInteger idx, BOOL * _Nonnull stop) {
        [lable removeFromSuperview];
        lable = nil;
    }];
    [self.tagLbs removeAllObjects];
    
    __block CGFloat contentWidth = _tags.count * FitPTScreen(3.5);
    [_tags enumerateObjectsUsingBlock:^(NSString*  _Nonnull tag, NSUInteger idx, BOOL * _Nonnull stop) {
        UILabel *lable = [UILabel hl_regularWithColor:@"#666666" font:12];
        lable.backgroundColor = UIColorFromRGB(0xF2F2F2);
        lable.text = tag;
        lable.textAlignment = NSTextAlignmentCenter;
        lable.layer.cornerRadius = FitPTScreen(1.5);
        lable.layer.masksToBounds = YES;
        [self.tagScroll addSubview:lable];
        [self.tagLbs addObject:lable];
        
        CGFloat width = [HLTools estmateWidthString:tag Font:[UIFont systemFontOfSize:FitPTScreen(12)]];
        contentWidth += width;
        if (idx == 0) {
            [lable makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.tagScroll);
            }];
        } else {
            UILabel *lastLb = self.tagLbs[idx -1];
            [lable makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(lastLb.right).offset(FitPTScreen(3.5));
            }];
        }
        
        [lable makeConstraints:^(MASConstraintMaker *make) {
            make.top.height.equalTo(self.tagScroll);
            make.width.equalTo(width + FitPTScreen(9));
        }];
    }];
    
    [self.tagScroll setContentSize:CGSizeMake(contentWidth, 0)];
}

- (void)setListModel:(HLHotListModel *)listModel {
    _listModel = listModel;
    _actiTipLb.text = listModel.typeName;;
    _storeNumLb.text = listModel.shopUseNum;
    [_headView sd_setImageWithURL:[NSURL URLWithString:listModel.pic]];
    _actiNameLb.text = listModel.title;
//    _peopleNumLb.text = listModel.orderNum;
    [_createBtn setTitle:listModel.butName forState:UIControlStateNormal];
    
    CGFloat width = [HLTools estmateWidthString:listModel.typeName Font:[UIFont systemFontOfSize:11]];
    [_actiTipLb updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(width + FitPTScreen(12));
    }];
    
    NSMutableArray *tags = [NSMutableArray array];
    for (HLHotClass *hotClass in listModel.huiSubClassList) {
        [tags addObject:hotClass.class_name];
    }
    self.tags = tags;
}

@end
