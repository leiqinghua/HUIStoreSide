//
//  HLBlueToothSetingController.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/11/23.
//

#import "HLBlueToothSetingController.h"
#import "HLBLEManager.h"

#import "HLRightInputViewCell.h"
#import "WHActionSheet.h"

@interface HLBlueToothSetingController ()<UITableViewDelegate,UITableViewDataSource,WHActionSheetDelegate>{

}

@property(strong,nonatomic)UITableView * tableView;

@property (strong,nonatomic)UILabel * nameLable;

@property (strong,nonatomic)UILabel * statuLable;

@property (strong,nonatomic)UIView * bottomView;

@property (strong,nonatomic)UIView * alertView;

@property(nonatomic,strong)NSArray * datasource;

@end

@implementation HLBlueToothSetingController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self hl_setTitle:@"设置"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(0xFAFAFA);
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, Height_NavBar, ScreenW, ScreenH - Height_NavBar) style:UITableViewStylePlain];
    _tableView.scrollEnabled = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];
    _tableView.rowHeight = FitPTScreen(40);
    [_tableView registerClass:[HLRightInputViewCell class] forCellReuseIdentifier:@"HLRightInputViewCell"];
    [self.view addSubview:_tableView];
     AdjustsScrollViewInsetNever(self, _tableView);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HLRightInputTypeInfo * info = self.datasource[indexPath.row];
    HLRightInputViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"HLRightInputViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.baseInfo = info;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1) {
         [self showAlertView];
    }
}


#pragma mark - WHActionSheetDelegate

- (void)actionSheet:(WHActionSheet *)actionSheet clickButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        //发请求断开连接
        [self disConnect];
    }
}

- (void)actionSheetCancle:(WHActionSheet *)actionSheet{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)showAlertView{
    WHActionSheet *actionSheet = [[WHActionSheet alloc] initWithTitle:@"" sheetTitles:@[@"断开连接"] cancleBtnTitle:@"取消" sheetStyle:(WHActionSheetDefault) delegate:self];
    actionSheet.isCorner = NO;
    actionSheet.subtitlebgColor = [UIColor whiteColor];
    actionSheet.subtitleColor = UIColorFromRGB(0xFF8604);
    actionSheet.canclebgColor = [UIColor whiteColor];
    actionSheet.cancleHeight = FitPTScreen(45);
    actionSheet.sheetHeight = FitPTScreen(45);
    actionSheet.cancelFont = [UIFont systemFontOfSize:FitPTScreen(14)];
    actionSheet.subtitleFont = [UIFont systemFontOfSize:FitPTScreen(14)];
    [actionSheet show];
}

- (void)disConnect{
    HLBLEManager * manager = [HLBLEManager shared];
    
    [manager cancelCurrentPeripheral:^{
        [self hl_goback];
    } loading:YES];
}


-(NSArray *)datasource{
    if (!_datasource) {
        HLRightInputTypeInfo * nameInfo = [[HLRightInputTypeInfo alloc]init];
        nameInfo.leftTip = [HLBLEManager shared].curPeripheral.name;;
        nameInfo.text = [HLBLEManager shared].curPeripheral.state ==CBPeripheralStateConnected?@"已连接":@"未连接";
        nameInfo.canInput = false;
        nameInfo.cellHeight = FitPTScreen(50);
        
        HLRightInputTypeInfo * offInfo = [[HLRightInputTypeInfo alloc]init];
        offInfo.leftTip = @"断开连接";
        offInfo.enabled = false;
        offInfo.cellHeight = FitPTScreen(50);
        offInfo.leftTipColor = UIColorFromRGB(0xFF8604);
        
        _datasource = @[nameInfo,offInfo];
        
    }
    return _datasource;
}
@end
