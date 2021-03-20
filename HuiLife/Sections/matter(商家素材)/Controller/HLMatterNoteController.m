//
//  HLMatterNoteController.m
//  HuiLife
//
//  Created by 王策 on 2019/8/27.
//

#import "HLMatterNoteController.h"
#import "HLMatterNoteCell.h"

@interface HLMatterNoteController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *contentHead;
@property (nonatomic, strong) UIView *contentBottom;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, copy) NSArray *dataSource;

@end

@implementation HLMatterNoteController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationOverFullScreen;
        self.view.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.3];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatSubViews];
}

- (void)setTextArr:(NSArray *)textArr {
    _textArr = textArr;
    
    NSMutableArray *mArr = [NSMutableArray array];
    CGFloat tableHeight = 0;
    for (NSInteger i = 0; i < textArr.count; i++) {
        HLMatterNoteLayout *layout = [[HLMatterNoteLayout alloc] init];
        layout.text = textArr[i];
        layout.index = [NSString stringWithFormat:@"%ld", i + 1];
        [mArr addObject:layout];
        tableHeight += layout.cellHeight;
    }
    
    self.dataSource = [mArr copy];
    
    _tableView.scrollEnabled = tableHeight > FitPTScreen(250);
    tableHeight = tableHeight > FitPTScreen(250) ? FitPTScreen(250) : tableHeight;
    
    _tableView.frame = CGRectMake(0, CGRectGetMaxY(_contentHead.frame), CGRectGetWidth(_contentHead.frame), tableHeight);
    _contentBottom.frame = CGRectMake(0, CGRectGetMaxY(_tableView.frame), CGRectGetWidth(_contentHead.frame), FitPTScreen(75));
    
    _contentView.frame = CGRectMake(FitPTScreen(35), 0, FitPTScreen(306), CGRectGetMaxY(_contentBottom.frame));
    _contentView.center = CGPointMake(ScreenW / 2, ScreenH / 2);
}

- (void)hidePage {
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)creatSubViews {
    
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(FitPTScreen(35), 0, FitPTScreen(306), FitPTScreen(200))];
    _contentView.center = CGPointMake(ScreenW / 2, ScreenH / 2);
    [self.view addSubview:_contentView];
    _contentView.backgroundColor = UIColor.whiteColor;
    _contentView.layer.cornerRadius = FitPTScreen(11);
    _contentView.layer.masksToBounds = YES;
    
    _contentHead = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _contentView.frame.size.width, FitPTScreen(70))];
    [_contentView addSubview:_contentHead];
    [self creatContentHeadSubViews];
    
    _contentBottom = [[UIView alloc] initWithFrame:CGRectMake(0, _contentView.frame.size.height - FitPTScreen(75), _contentView.frame.size.width, FitPTScreen(75))];
    [_contentView addSubview:_contentBottom];
    [self creatContentBottomSubViews];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[HLMatterNoteCell class] forCellReuseIdentifier:@"HLMatterNoteCell"];
    [_contentView addSubview:_tableView];
    AdjustsScrollViewInsetNever(self, _tableView);
}

- (void)creatContentBottomSubViews {
    
    UIButton *button = [[UIButton alloc] init];
    [_contentBottom addSubview:button];
    [button setBackgroundImage:[UIImage imageNamed:@"matter_note_ok"] forState:UIControlStateNormal];
    [button makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_contentBottom);
        make.width.equalTo(FitPTScreen(155));
        make.height.equalTo(FitPTScreen(66));
    }];
    [button addTarget:self action:@selector(hidePage) forControlEvents:UIControlEventTouchUpInside];
}

- (void)creatContentHeadSubViews {
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mater_note_top"]];
    [_contentHead addSubview:imageView];
    [imageView makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_contentHead);
        make.height.equalTo(FitPTScreen(14));
        make.width.equalTo(FitPTScreen(116));
    }];
    
    UILabel *titleLab = [[UILabel alloc] init];
    [imageView addSubview:titleLab];
    titleLab.text = @"素材使用说明";
    titleLab.textColor = UIColorFromRGB(0x222222);
    titleLab.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    [titleLab makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(imageView);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HLMatterNoteCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HLMatterNoteCell" forIndexPath:indexPath];
    cell.noteLayout = self.dataSource[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    HLMatterNoteLayout *layout = self.dataSource[indexPath.row];
    return layout.cellHeight;
}

@end
