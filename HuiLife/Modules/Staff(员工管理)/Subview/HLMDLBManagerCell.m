//
//  HLMDLBManagerCell.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/7/23.
//

#import "HLMDLBManagerCell.h"
#import "HLWithNotImgAlertView.h"

@interface HLMDLBManagerCell()
{
    UIView *toplineview;
}
@property(strong,nonatomic)UILabel * titleLable;
@property(strong,nonatomic)UIButton *selectView;

@end
@implementation HLMDLBManagerCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

-(void)createUI{
    self.contentView.backgroundColor = UIColorFromRGB(0xF2F2F2);
    _titleLable = [[UILabel alloc]init];
    _titleLable.textColor = UIColorFromRGB(0x656565);
    _titleLable.font = [UIFont systemFontOfSize:FitPTScreenH(14)];
    _titleLable.text = @"四川火锅";
    [self.contentView addSubview:_titleLable];
    [_titleLable makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(FitPTScreen(40));
    }];
    
    _selectView = [[UIButton alloc]init];
    [_selectView setImage:[UIImage imageNamed:@"select_md_normal"] forState:UIControlStateNormal];
    [_selectView setImage:[UIImage imageNamed:@"select_md_selected"] forState:UIControlStateSelected];
    [self addSubview:_selectView];
    [_selectView makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(FitPTScreen(-15));
        make.width.height.equalTo(40);
    }];
    
    [_selectView addTarget:self action:@selector(selectViewClick:) forControlEvents:UIControlEventTouchUpInside];
    
    toplineview = [[UIView alloc]init];
    toplineview.backgroundColor =UIColorFromRGB(0xDDDDDD);
    [self.contentView addSubview:toplineview];
    [toplineview makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(FitPTScreen(10));
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-1);
        make.height.equalTo(FitPTScreen(1));
        make.width.equalTo(FitPTScreen(355));
    }];
    //delete_leibie
}

-(void)setSelectLB:(BOOL)isSelect{
    _selectView.selected = isSelect;
}
-(void)setIsSelect:(BOOL)isSelect{
    _isSelect = isSelect;
    if (!_isSelect) {
        [_selectView setImage:[UIImage imageNamed:@"delete_yellow"] forState:UIControlStateNormal];
        [_selectView setImage:[UIImage imageNamed:@"delete_yellow"] forState:UIControlStateSelected];
    }else{
        [_selectView setImage:[UIImage imageNamed:@"select_md_normal"] forState:UIControlStateNormal];
        [_selectView setImage:[UIImage imageNamed:@"select_md_selected"] forState:UIControlStateSelected];
    }
}

-(void)selectViewClick:(UIButton *)sender{
    sender.selected = !sender.selected;
    [self.superview endEditing:YES];
    if (_isSelect&&_indexpath&&self.delegate) {
        [self.delegate didselectcellAt:_indexpath sender:sender];
    }else{
        MJWeakSelf;
        HLWithNotImgAlertView *alertView = [[HLWithNotImgAlertView alloc]initWithTitle:@"是否删除类别" subTitle:_titleLable.text hight:FitPTScreen(155) subColor:UIColorFromRGB(0xFF8D26) oncern:^{
            if (weakSelf.delegate) {
                [weakSelf.delegate deleteSmallClassAtIndexPath:weakSelf.indexpath];
            }
        } cancel:^{
            
        }];
        
        [KEY_WINDOW addSubview:alertView];
    }
}
/*
 {
 class = 123111;
 classname = 123111;
 id = 28752;
 }
 */
-(void)setContentWithDict:(NSDictionary *)dict{
    if (dict) {
        self.titleLable.text = dict[@"classname"];
    }
}
//取消选中
-(void)cancelSelect{
    _selectView.selected = NO;
}

-(void)hideLine:(BOOL)hide{
    toplineview.hidden = hide;
}
@end
