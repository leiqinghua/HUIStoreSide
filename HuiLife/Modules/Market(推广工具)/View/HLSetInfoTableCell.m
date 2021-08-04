//
//  HLSetInfoTableCell.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/8/3.
//

#import "HLSetInfoTableCell.h"
#import "HLTextFieldTableCell.h"
#import "HLTextViewTableCell.h"

@interface HLSetInfoTableCell()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UIView * bagView;

@property(nonatomic,strong)UITableView * tableView;


@end

@implementation HLSetInfoTableCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initView];
    }
    return self;
}

-(void)initView{
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
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(FitPTScreen(5), FitPTScreen(13), FitPTScreen(5), FitPTScreen(13)));
    }];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableFooterView = [UIView new];
    _tableView.backgroundColor = UIColor.whiteColor;
    _tableView.scrollEnabled = false;
    [self.bagView addSubview:_tableView];
    [_tableView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.bagView).insets(UIEdgeInsetsMake(1, 1, 1, 1));
        make.height.equalTo(FitPTScreen(322)).priorityLow();
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _mainModel.inputs.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HLBaseInputModel * inputModel = _mainModel.inputs[indexPath.row];
   
    if (inputModel.type == HLBaseInputFieldType) {
        HLTextFieldTableCell * cell = [HLTextFieldTableCell dequeueReusableCell:tableView];
        cell.inputModel = inputModel;
        return cell;
    }
    if (inputModel.type == HLBaseInputTextViewType) {
        HLTextViewTableCell * cell = [HLTextViewTableCell dequeueReusableCell:tableView];
        cell.inputModel = inputModel;
        return cell;
    }
    HLTradeTimeViewCell * cell = [HLTradeTimeViewCell dequeueReusableCell:tableView];
    cell.inputModel = inputModel;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    HLBaseInputModel * inputModel = _mainModel.inputs[indexPath.row];
    return inputModel.cellHight;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HLBaseInputModel * inputModel = _mainModel.inputs[indexPath.row];
    if ([self.delegate respondsToSelector:@selector(infoCell:selectWithModel:)]) {
        [self.delegate infoCell:self selectWithModel:inputModel];
    }
}

-(void)setMainModel:(HLSetModel *)mainModel{
    _mainModel = mainModel;
    [self.tableView updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(mainModel.inputViewH).priorityLow();
    }];

    [self.tableView reloadData];
}

@end
