//
//  HLExportRecordCell.m
//  HuiLife
//
//  Created by 雷清华 on 2020/10/11.
//

#import "HLExportRecordCell.h"
#import "HLCustomerInfo.h"

@interface HLExportRecordCell ()
@property(nonatomic, strong)UILabel *numLb;
@property(nonatomic, strong)UILabel *nameLb;
@property(nonatomic, strong)UILabel *timeLb;
@property(nonatomic, strong) UIButton *downBtn;
@property(nonatomic, strong) UIView *bagView;
@end

@implementation HLExportRecordCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initSubView];
    }
    return self;
}

- (void)initSubView {
    _bagView = [[UIView alloc]init];
    _bagView.backgroundColor = UIColor.whiteColor;
    [self.contentView addSubview:_bagView];
    [_bagView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, FitPTScreen(12), 0, FitPTScreen(12)));
    }];
    
    _numLb = [UILabel hl_regularWithColor:@"#565656" font:12];
    [_bagView addSubview:_numLb];
    [_numLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(9));
        make.centerY.equalTo(self.bagView);
    }];
    
    _nameLb = [UILabel hl_regularWithColor:@"#565656" font:12];
    [_bagView addSubview:_nameLb];
    [_nameLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.numLb.right).offset(FitPTScreen(18));
        make.centerY.equalTo(self.bagView);
        make.width.lessThanOrEqualTo(FitPTScreen(100));
    }];

    _downBtn = [UIButton hl_regularWithTitle:@"下载" titleColor:@"#565656" font:12 image:@""];
    _downBtn.layer.cornerRadius = FitPTScreen(6);
    _downBtn.layer.borderColor = UIColorFromRGB(0xDADADA).CGColor;
    _downBtn.layer.borderWidth = 0.5;
    [_bagView addSubview:_downBtn];
    [_downBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-10));
        make.centerY.equalTo(self.bagView);
        make.size.equalTo(CGSizeMake(FitPTScreen(48), FitPTScreen(23)));
    }];
    [_downBtn addTarget:self action:@selector(downClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _timeLb = [UILabel hl_regularWithColor:@"#565656" font:12];
    [_bagView addSubview:_timeLb];
    [_timeLb makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.downBtn.left).offset(FitPTScreen(-11));
        make.centerY.equalTo(self.bagView);
    }];
}

- (void)configBackgroundColor:(NSString *)color {
    self.bagView.backgroundColor = [UIColor hl_StringToColor:color];
}

//- (void)setInfo:(HLExportRecordInfo *)info {
//    _info = info;
//    _numLb.text = [NSString stringWithFormat:@"%ld/条",info.sum];
//    _nameLb.text = info.fileName;
//    _timeLb.text = info.exportTime;
//
//    NSString *dirPath = [HLFileManager cusExportDir];
//    if (dirPath.length) {
//        NSString *filePath = [dirPath stringByAppendingPathComponent:info.fileUrl.lastPathComponent];
//        if ([HLFileManager existFile:filePath]) { //如果存在
//            info.filePath = filePath;
//            info.done = YES;
//        }
//    }
//    if (!info.fileName.length) {
//        info.filePath = @"";
//        info.done = NO;
//    }
//    [_downBtn setTitle:(info.done?@"预览":@"下载") forState:UIControlStateNormal];
//}


- (void)configNum:(NSInteger)num name:(NSString *)name time:(NSString *)time done:(BOOL)done {
    _numLb.text = [NSString stringWithFormat:@"%ld/条",num];
    _nameLb.text = name;
    _timeLb.text = time;
    [_downBtn setTitle:(done?@"预览":@"下载") forState:UIControlStateNormal];
}

- (void)downClick:(UIButton *)sender {
//    if ([self.delegate respondsToSelector:@selector(recordCell:downWithInfo:)]) {
//        [self.delegate recordCell:self downWithInfo:self.info];
//    }
    if ([self.delegate respondsToSelector:@selector(recordCell:index:)]) {
        [self.delegate recordCell:self index:_index];
    }
}
@end
