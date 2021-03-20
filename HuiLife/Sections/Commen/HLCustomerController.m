//
//  HLCustomerController.m
//  HuiLife
//
//  Created by 雷清华 on 2019/8/27.
//

#import "HLCustomerController.h"

@interface HLCustomerController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UITableView * tableView;

@property(nonatomic,strong)NSMutableArray * datasource;

@property(nonatomic, assign) BOOL loaded;


@end

@implementation HLCustomerController

- (void)viewWillAppear:(BOOL)animated {}

- (void)loadCustomData {
    if (_loaded) return;
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/shopplus/Customerservice/index";
        request.serverType = HLServerTypeStoreService;
        request.parameters =@{};
    } onSuccess:^(id responseObject) {
        HLHideLoading(self.view);
        // 处理数据
        XMResult * result = (XMResult *)responseObject;
        if(result.code == 200){
            [self handleData:result.data];
        }
    } onFailure:^(NSError *error) {
        HLHideLoading(self.view);
    }];
}

- (void)handleData:(NSDictionary *)dict {
    NSString * qq = dict[@"qq"];
    NSString * tel = dict[@"tel"];
    NSString * time = dict[@"time_blue"];
    if (qq.length) {
        HLCustomerModel * model1 = [[HLCustomerModel alloc]init];
        model1.leftPic = @"qq";
        model1.title = qq;
        model1.text = [NSString stringWithFormat:@"qq：%@",qq];
        [self.datasource addObject:model1];
    }
    
    if (tel.length) {
        HLCustomerModel * model = [[HLCustomerModel alloc]init];
        model.leftPic = @"phone_kf";
        model.phone = YES;
        model.title = tel;
        model.text = [NSString stringWithFormat:@"客服电话：%@",tel];
        model.rightPic = @"phone_green_cricle";
        [self.datasource addObject:model];
    }
    
    if (time.length) {
        HLCustomerModel * model2 = [[HLCustomerModel alloc]init];
        model2.leftPic = @"time_blue";
        model2.title = time;
        model2.text = [NSString stringWithFormat:@"工作时间：%@",time];
        [self.datasource addObject:model2];
    }
    
    if (self.datasource.count) {
        _loaded = YES;
    }
    
    [self.tableView reloadData];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, Height_NavBar, ScreenW, ScreenH - Height_NavBar)];
    _tableView.backgroundColor = UIColor.whiteColor;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = FitPTScreen(90);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    AdjustsScrollViewInsetNever(self, _tableView);
    
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, FitPTScreen(255))];
    _tableView.tableHeaderView = headerView;
    
    UIImageView * logoView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"phone_kf_2"]];
    [headerView addSubview:logoView];
    [logoView makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headerView);
        make.top.equalTo(FitPTScreen(40));
    }];
    
    UILabel * tipLb = [[UILabel alloc]init];
    tipLb.text = @"您在商+号，使用过程的任何问题";
    tipLb.textColor = UIColorFromRGB(0x999999);
    tipLb.font = [UIFont systemFontOfSize:FitPTScreen(12)];
    [headerView addSubview:tipLb];
    [tipLb makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headerView);
        make.top.equalTo(logoView.bottom).offset(FitPTScreen(50));
    }];
    
    UILabel * subLb = [[UILabel alloc]init];
    subLb.text = @"请联系我们客服";
    subLb.textColor = UIColorFromRGB(0xFF881F);
    subLb.font = [UIFont systemFontOfSize:FitPTScreen(13)];
    [headerView addSubview:subLb];
    [subLb makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headerView);
        make.top.equalTo(tipLb.bottom).offset(FitPTScreen(10));
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HLCustomerTableCell * cell = [HLCustomerTableCell dequeueReusableCell:tableView];
    cell.model = self.datasource[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HLCustomerModel * model = self.datasource[indexPath.row];
    if (model.phone) {
        [HLTools callPhone:model.title];
    }
}

- (NSMutableArray *)datasource {
    if (!_datasource) {
        _datasource = [NSMutableArray array];
    }
    return _datasource;
}

@end


@interface HLCustomerTableCell ()

@property(nonatomic,strong)UIImageView * leftImgV;

@property(nonatomic,strong)UILabel * titleLb;

@property(nonatomic,strong)UIImageView * rightImgV;

@property(nonatomic,strong)UIView * bagView;

@end

@implementation HLCustomerTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initView];
    }
    return self;
}

- (void)initView {
    
    self.backgroundColor = UIColor.clearColor;
    _bagView = [[UIView alloc]init];
    _bagView.backgroundColor = UIColor.whiteColor;
    _bagView.layer.shadowColor = [UIColor colorWithRed:223/255.0 green:223/255.0 blue:223/255.0 alpha:0.42].CGColor;
    _bagView.layer.shadowOffset = CGSizeMake(0,1);
    _bagView.layer.shadowOpacity = 1;
    _bagView.layer.shadowRadius = FitPTScreen(26);
    _bagView.layer.cornerRadius = FitPTScreen(5.5);
    _bagView.layer.masksToBounds = false;
    [self.contentView addSubview:_bagView];
    [_bagView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(FitPTScreen(6), FitPTScreen(13), FitPTScreen(6), FitPTScreen(13)));
    }];
    
    _leftImgV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@""]];
    [_bagView addSubview:_leftImgV];
    [_leftImgV makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(11));
        make.centerY.equalTo(_bagView);
    }];
    
    _titleLb = [[UILabel alloc]init];
    _titleLb.font = [UIFont systemFontOfSize:FitPTScreen(15)];
    [_bagView addSubview:_titleLb];
    [_titleLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftImgV.right).offset(FitPTScreen(10));
        make.centerY.equalTo(_bagView);
    }];
    
    _rightImgV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@""]];
    [_bagView addSubview:_rightImgV];
    [_rightImgV makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-15));
        make.centerY.equalTo(_bagView);
    }];
    
}

-(void)setModel:(HLCustomerModel *)model{
    _model = model;
    _leftImgV.image = [UIImage imageNamed:model.leftPic];
    _titleLb.attributedText = model.titleAttr;
    _rightImgV.image = [UIImage imageNamed:model.rightPic];
}

@end


@implementation HLCustomerModel

-(NSAttributedString *)titleAttr{
    if (!_titleAttr) {
        NSRange range = [_text rangeOfString:_title];
        NSMutableAttributedString * attr = [[NSMutableAttributedString alloc]initWithString:_text attributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0x333333)}];
        [attr addAttributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0x666666)} range:range];
        _titleAttr = [attr copy];
    }
    return _titleAttr;
}

@end
