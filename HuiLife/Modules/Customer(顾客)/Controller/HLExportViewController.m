//
//  HLExportViewController.m
//  HuiLife
//
//  Created by 雷清华 on 2020/9/7.
//

#import "HLExportViewController.h"
#import "LZPickViewManager.h"
#import "HLStatuAlert.h"

#define kiOSStartTimeTip @"请选择开始时间"
#define kiOSEndTimeTip  @"请选择结束时间"

@interface HLExportViewController ()
@property(nonatomic, strong) UILabel *numLb;
@property(nonatomic, strong) UILabel *startLb;
@property(nonatomic, strong) UILabel *endLb;
@property(nonatomic, strong) UILabel *timeNumLb;
@property(nonatomic, strong) UITextField *fileNameField;
@end

@implementation HLExportViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self hl_setTitle:@"会员导出"];
    [self hl_setBackImage:@"back_oriange"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubView];
}

#pragma mark - Request
- (void)loadNumWithStart:(NSString *)startTime endTime:(NSString *)endTime {
    NSDictionary *pargram = @{
            @"userIdBuss":[HLAccount shared].userIdBuss?:@"",
            @"startTime" :startTime,
            @"endTime"   :endTime
    };
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/CardBag/mybag/CustomerCount.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = pargram;
    } onSuccess:^(id responseObject) {
        HLHideLoading(self.view);
        XMResult *result = (XMResult *)responseObject;
        if (result.code == 200) {
            NSString *num = [NSString stringWithFormat:@"%@",result.data[@"sum"]];
            NSString *timeNumStr = [NSString stringWithFormat:@"该时间段共有%@位会员",num];
            self.timeNumLb.text = timeNumStr;
            return;
        }
    }onFailure:^(NSError *error) {
        HLHideLoading(self.view);
    }];
}

//会员导出
- (void)exportWithStartTime:(NSString *)startTime endTime:(NSString *)endTime {
    NSDictionary *pargram = @{
            @"userIdBuss":[HLAccount shared].userIdBuss?:@"",
            @"startTime" :startTime,
            @"endTime"   :endTime,
            @"fileName"  :_fileNameField.text
    };
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/CardBag/mybag/CustomerExport.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = pargram;
    } onSuccess:^(id responseObject) {
        HLHideLoading(self.view);
        XMResult *result = (XMResult *)responseObject;
        if (result.code == 200) {
            NSInteger count = [result.data[@"active"][@"user_count"] integerValue];
            NSString *message = [NSString stringWithFormat:@"成功导出%ld位会员\n请前往导出记录下载",count];
            [HLStatuAlert showWithStatuPic:@"success" message:message callBack:^(void){
                
            }];
            
            return;
        }
    }onFailure:^(NSError *error) {
        HLHideLoading(self.view);
    }];
}
#pragma mark - Event
//导出记录
- (void)recordClick {
    [HLTools pushAppPageLink:@"HLExportRecordController" params:@{} needBack:NO];
}

//导出
- (void)exportClick {
    
    if ([_startLb.text isEqualToString:kiOSStartTimeTip] && [_endLb.text isEqualToString:kiOSEndTimeTip]) {
        HLShowHint(@"请选择时间范围", self.view);
        return;
    }
    
    if (!_fileNameField.text.length) {
        HLShowHint(@"请输入文件名称", self.view);
        return;
    }
    
    if (_fileNameField.text.length > 10) {
        HLShowHint(@"文件名称不能超过10个字", self.view);
        return;
    }
    
    NSString *startTime = self.startLb.text;
    NSString *endTime = self.endLb.text;
    if ([startTime isEqualToString:kiOSStartTimeTip]) {
        startTime = @"2010-01-01";
    }
    if ([endTime isEqualToString:kiOSEndTimeTip]) {
        endTime = [HLTools formatterWithDate:[NSDate date] formate:@"yyyy-MM-dd"];
    }
    [self exportWithStartTime:startTime endTime:endTime];
}

//重置时间
- (void)resetClick {
    _startLb.text = kiOSStartTimeTip;
    _endLb.text = kiOSEndTimeTip;
    self.timeNumLb.text = @"";
}

//开始时间
- (void)startClick:(UIButton *)sender {
    NSString * max = [HLTools formatterWithDate:[NSDate date] formate:@"yyyy-MM-dd"];
    [[LZPickViewManager initLZPickerViewManager] showWithMaxDateString:max withMinDateString:@"2010-01-01" didSeletedDateStringBlock:^(NSString *dateString) {
        HLLog(@"dateString = %@",dateString);
        
        NSInteger compare = [HLTools compareWithFirst:dateString another:_endLb.text formate:@"yyyy-MM-dd"];
        if (compare == -1) {
            HLShowHint(@"开始时间不能晚于结束时间", self.view);
            return;
        }
        self.startLb.text = dateString;
        NSString *endTime = self.endLb.text;
        if ([self.endLb.text isEqualToString:kiOSEndTimeTip]) {
            endTime = [HLTools formatterWithDate:[NSDate date] formate:@"yyyy-MM-dd"];
        }
//        请求
        [self loadNumWithStart:dateString endTime:endTime];
    }];
}
//结束时间
- (void)endClick:(UIButton *)sender {
     NSString * max = [HLTools formatterWithDate:[NSDate date] formate:@"yyyy-MM-dd"];
        [[LZPickViewManager initLZPickerViewManager] showWithMaxDateString:max withMinDateString:@"2010-01-01" didSeletedDateStringBlock:^(NSString *dateString) {
            HLLog(@"dateString = %@",dateString);
            NSInteger compare = [HLTools compareWithFirst:dateString another:_startLb.text formate:@"yyyy-MM-dd"];
            if (compare == 1) {
                HLShowHint(@"结束时间不能早于开始时间", self.view);
                return;
            }
            self.endLb.text = dateString;
            NSString *startTime = self.startLb.text;
            if ([self.startLb.text isEqualToString:kiOSStartTimeTip]) {
                startTime = @"2010-01-01";
            }
            [self loadNumWithStart:startTime endTime:dateString];
        }];
}
#pragma mark - UIView
- (void)initSubView {
    UIImageView *bagImgV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cus_export_bag"]];
    [self.view addSubview:bagImgV];
    [bagImgV makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(Height_NavBar);
        make.height.equalTo(FitPTScreen(80));
    }];
    
    _numLb = [UILabel hl_regularWithColor:@"#FFFFFF" font:14];
    [bagImgV addSubview:_numLb];
    [_numLb makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(bagImgV);
    }];
    if (_num.intValue > 0) {
        NSString *numStr = [NSString stringWithFormat:@"本店共有%@位会员",_num];
       NSMutableAttributedString *numAttr = [[NSMutableAttributedString alloc]initWithString:numStr];
        [numAttr addAttributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0xFD9E2F),NSFontAttributeName:[UIFont systemFontOfSize:FitPTScreen(19)]} range:[numStr rangeOfString:_num]];
        _numLb.attributedText = numAttr;
    }
    
    UILabel *tipLb = [UILabel hl_regularWithColor:@"#222222" font:14];
    tipLb.text = @"选择时间范围";
    [self.view addSubview:tipLb];
    [tipLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(13));
        make.top.equalTo(bagImgV.bottom).offset(FitPTScreen(25));
    }];

    UIButton *startBtn = [[UIButton alloc]init];
    startBtn.backgroundColor = UIColor.whiteColor;
    startBtn.layer.cornerRadius = FitPTScreen(3);
    startBtn.layer.borderColor = UIColorFromRGB(0xDADADA).CGColor;
    startBtn.layer.borderWidth = 0.5;
    [self.view addSubview:startBtn];
    [startBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(12));
        make.top.equalTo(tipLb.bottom).offset(FitPTScreen(10));
        make.size.equalTo(CGSizeMake(FitPTScreen(171), FitPTScreen(41)));
    }];
    
    UIImageView *startTipImV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cus_calander"]];
    [startBtn addSubview:startTipImV];
    [startTipImV makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(16));
        make.centerY.equalTo(startBtn);
    }];
    
    _startLb = [UILabel hl_regularWithColor:@"#565656" font:14];
    _startLb.text = kiOSStartTimeTip;
    [startBtn addSubview:_startLb];
    [_startLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(startTipImV.right).offset(FitPTScreen(10));
        make.centerY.equalTo(startBtn);
        make.size.equalTo(CGSizeMake(FitPTScreen(120), FitPTScreen(30)));
    }];
    
    UIButton *endBtn = [[UIButton alloc]init];
    endBtn.backgroundColor = UIColor.whiteColor;
    endBtn.layer.cornerRadius = FitPTScreen(3);
    endBtn.layer.borderColor = UIColorFromRGB(0xDADADA).CGColor;
    endBtn.layer.borderWidth = 0.5;
    [self.view addSubview:endBtn];
    [endBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(startBtn.right).offset(FitPTScreen(10));
        make.centerY.equalTo(startBtn);
        make.size.equalTo(CGSizeMake(FitPTScreen(171), FitPTScreen(41)));
    }];
    
    UIImageView *endTipImV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cus_calander"]];
    [endBtn addSubview:endTipImV];
    [endTipImV makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(16));
        make.centerY.equalTo(endBtn);
    }];
    
    _endLb = [UILabel hl_regularWithColor:@"#565656" font:14];
    _endLb.text = kiOSEndTimeTip;
    [endBtn addSubview:_endLb];
    [_endLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(endTipImV.right).offset(FitPTScreen(10));
        make.centerY.equalTo(endBtn);
        make.size.equalTo(CGSizeMake(FitPTScreen(120), FitPTScreen(30)));
    }];
    
    _timeNumLb = [UILabel hl_regularWithColor:@"#9A9A9A" font:12];
    [self.view addSubview:_timeNumLb];
    [_timeNumLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(12));
        make.top.equalTo(startBtn.bottom).offset(FitPTScreen(15));
    }];
    
    UIButton *resetBtn = [UIButton hl_regularWithTitle:@" 重置时间" titleColor:@"#9A9A9A" font:12 image:@"reset"];
    [self.view addSubview:resetBtn];
    [resetBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-12));
        make.centerY.equalTo(self.timeNumLb);
    }];
    [resetBtn addTarget:self action:@selector(resetClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *topLine = [[UIView alloc]init];
    topLine.backgroundColor = UIColorFromRGB(0xEDEDED);
    [self.view addSubview:topLine];
    [topLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(12));
        make.right.equalTo(FitPTScreen(-12));
        make.top.equalTo(self.timeNumLb.bottom).offset(FitPTScreen(20));
        make.height.equalTo(0.5);
    }];
    
    UILabel *fileTypeLb = [UILabel hl_regularWithColor:@"#222222" font:14];
    fileTypeLb.text = @"导出文件类型为：";
    [self.view addSubview:fileTypeLb];
    [fileTypeLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(12));
        make.top.equalTo(topLine.bottom).offset(FitPTScreen(18));
    }];
    
    UIButton *fileTypeBtn = [UIButton hl_regularWithTitle:@" Excel" titleColor:@"#666666" font:14 image:@"excel"];
    [self.view addSubview:fileTypeBtn];
    [fileTypeBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(fileTypeLb.right).offset(FitPTScreen(5));
        make.centerY.equalTo(fileTypeLb);
    }];
    
    UIView *bottomLine = [[UIView alloc]init];
    bottomLine.backgroundColor = UIColorFromRGB(0xEDEDED);
    [self.view addSubview:bottomLine];
    [bottomLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(12));
        make.right.equalTo(FitPTScreen(-12));
        make.top.equalTo(topLine.bottom).offset(FitPTScreen(50));
        make.height.equalTo(0.5);
    }];
    [startBtn addTarget:self action:@selector(startClick:) forControlEvents:UIControlEventTouchUpInside];
    [endBtn addTarget:self action:@selector(endClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UILabel *fileNameLb = [UILabel hl_regularWithColor:@"#222222" font:14];
    fileNameLb.text = @"文件名称";
    [self.view addSubview:fileNameLb];
    [fileNameLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(12));
        make.top.equalTo(bottomLine.bottom).offset(FitPTScreen(20));
    }];
    
    _fileNameField = [[UITextField alloc]init];
    _fileNameField.tintColor = UIColorFromRGB(0xFD9E30);
    _fileNameField.layer.cornerRadius = FitPTScreen(3);
    _fileNameField.layer.borderColor = UIColorFromRGB(0xDADADA).CGColor;
    _fileNameField.layer.borderWidth = 0.5;
    _fileNameField.placeholder = @"请输入文件名称";
    _fileNameField.textColor = UIColorFromRGB(0x222222);
    _fileNameField.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    _fileNameField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, FitPTScreen(13), 30)];
    _fileNameField.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:_fileNameField];
    [_fileNameField makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(12));
        make.right.equalTo(FitPTScreen(-12));
        make.top.equalTo(fileNameLb.bottom).offset(FitPTScreen(14));
        make.size.equalTo(CGSizeMake(FitPTScreen(351), FitPTScreen(44)));
    }];
    
    UIButton *exportBtn = [UIButton hl_regularWithTitle:@"确定导出" titleColor:@"#FFFFFF" font:13 image:@""];
    exportBtn.layer.cornerRadius = FitPTScreen(20);
    exportBtn.backgroundColor = UIColorFromRGB(0xFD9E30);
    [self.view addSubview:exportBtn];
    [exportBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(12));
        make.right.equalTo(FitPTScreen(-12));
        make.top.equalTo(self.fileNameField.bottom).offset(FitPTScreen(35));
        make.height.equalTo(FitPTScreen(40));
    }];
    [exportBtn addTarget:self action:@selector(exportClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *recordBtn = [UIButton hl_regularWithTitle:@"导出记录" titleColor:@"#FE9E30" font:13 image:@""];
    UIBarButtonItem *exportItem = [[UIBarButtonItem alloc]initWithCustomView:recordBtn];
    self.navigationItem.rightBarButtonItem = exportItem;
    [recordBtn addTarget:self action:@selector(recordClick) forControlEvents:UIControlEventTouchUpInside];
}

@end
