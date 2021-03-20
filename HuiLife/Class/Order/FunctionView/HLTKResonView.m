//
//  HLTKResonView.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/10/9.
//

#import "HLTKResonView.h"
#import "HLTKReasonViewCell.h"

const CGFloat commenHight = 50;
const CGFloat tableCellHight = 44;

@interface HLTKResonView()<UITableViewDelegate,UITableViewDataSource>{
    NSIndexPath *_selectIndexPath;
//    SelectBlock callBack;
}

@property(strong,nonatomic)NSArray * dataSource;

@property (strong,nonatomic)UITableView * tableView;

@property (strong,nonatomic)UIView * bagView;

@property (strong,nonatomic)UIView * bottomView;

@property (copy,nonatomic)SelectBlock callBack;

@property (assign,nonatomic)NSInteger selectIndex;
@end

@implementation HLTKResonView

-(instancetype)initWithFrame:(CGRect)frame dataSource:(NSArray *)reasons{
    if (self = [super initWithFrame:frame]) {
        _dataSource = reasons;
        [self createUIWithFrame:frame];
    }
    return self;
}

+ (void)showWithFrame:(CGRect)frame dataSource:(NSArray *)reasons selectIndex:(NSInteger)index callBack:(SelectBlock)block{
     HLTKResonView * resonView = [[HLTKResonView alloc]initWithFrame:frame dataSource:reasons];
    resonView.callBack = block;
    resonView.selectIndex = index;
    [resonView showAnimateView];
}

- (void)concernClick:(UIButton *)sender{
    if (self.callBack) {
        self.callBack(self.dataSource[_selectIndexPath.row], _selectIndexPath.row);
        [self hideView];
    }
}

- (void)cancelClick:(UIButton *)sender{
    [self hideView];
}

- (void)showAnimateView{
    [UIView animateWithDuration:0.3 animations:^{
        self.bottomView.frame = CGRectMake(0, ScreenH - commenHight * 2 - self.dataSource.count * tableCellHight - FitPTScreen(10), ScreenW, commenHight * 2 + self.dataSource.count * tableCellHight + FitPTScreen(10));
    }];
}

- (void)hideView{
    [UIView animateWithDuration:0.3 animations:^{
        self.bottomView.frame = CGRectMake(0, ScreenH, ScreenW, commenHight * 2 + self.dataSource.count * tableCellHight);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)createUIWithFrame:(CGRect)frame{
    _bagView = [[UIView alloc]initWithFrame:frame];
    _bagView.backgroundColor = [UIColor blackColor];
    _bagView.alpha = 0.5;
    [self addSubview:_bagView];

    UIView * bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenH, ScreenW, commenHight * 2 + self.dataSource.count * tableCellHight)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bottomView];
    _bottomView = bottomView;
    
    UIView * topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, commenHight)];
    [bottomView addSubview:topView];
    
    UILabel * reasonLable = [[UILabel alloc]init];
    reasonLable.text = @"退款原因";
    reasonLable.textColor = UIColorFromRGB(0xFF333333);
    [reasonLable setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17]];
    [topView addSubview:reasonLable];
    [reasonLable makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(topView);
    }];
    
    UIButton * cancelBtn = [[UIButton alloc]init];
    [cancelBtn setImage:[UIImage imageNamed:@"close_x_grey"] forState:UIControlStateNormal];
    [topView addSubview:cancelBtn];
    [cancelBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-13));
        make.centerY.equalTo(topView);
        make.width.height.equalTo(FitPTScreen(20));
    }];
    [cancelBtn addTarget:self action:@selector(cancelClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(topView.frame), ScreenW, self.dataSource.count * tableCellHight) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[HLTKReasonViewCell class] forCellReuseIdentifier:@"HLTKReasonViewCell"];
    [bottomView addSubview:_tableView];
    
    UIButton * concernBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.tableView.frame)+FitPTScreen(10), ScreenW, commenHight)];
    [concernBtn setTitle:@"确定" forState:UIControlStateNormal];
    [concernBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    concernBtn.backgroundColor = UIColorFromRGB(0xFFFF8D26);
    [bottomView addSubview:concernBtn];
    [concernBtn addTarget:self action:@selector(concernClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [KEY_WINDOW addSubview:self];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HLTKReasonViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"HLTKReasonViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = self.dataSource[indexPath.row];
    _selectIndexPath = [NSIndexPath indexPathForRow:_selectIndex inSection:0];
    [tableView selectRowAtIndexPath:_selectIndexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return tableCellHight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:_selectIndexPath animated:YES];
    [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    _selectIndexPath = indexPath;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [self removeFromSuperview];
    [self hideView];
}
@end
