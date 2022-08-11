//
//  HLNextAddPrinterController.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/11/23.
//

#import "HLNextAddPrinterController.h"
//#import <UITextView+ZWPlaceHolder.h>
#import "HLButtonsView.h"
#import "HLTextFieldCheckInputNumberTool.h"

@interface HLNextAddPrinterController ()<UIScrollViewDelegate,UITextFieldDelegate,UITextViewDelegate,HLButtonsViewDelegate>{
    
    HLButtonsView * _buttonsView;
    
    HLTextFieldCheckInputNumberTool * _textFieldtool;
    
    HLTextFieldCheckInputNumberTool * _textViewtool;
}

@property (strong,nonatomic)UIScrollView *scrollView;

@property (strong,nonatomic)UISwitch *switchView;

@property (strong,nonatomic)UITextField *textField;

@property (strong,nonatomic)UITextView *textView;


@end

@implementation HLNextAddPrinterController

-(void)viewWillAppear:(BOOL)animated{
    [self hl_setTitle:_isAdd?@"添加打印机":@"打印机内容设置"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(0xFAFAFA);
    [self creatFootView];
    [self initSubViews];
    //初始化默认值
    [self.pargram setValue:[@[@"1",@"2",@"3",@"4"] mj_JSONString] forKey:@"custom_info"];
    
    if (!_isAdd) {//加载默认信息
        [self loadDataWithType:3];
    }
}

/// 构建底部的view
- (void)creatFootView{
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenH - FitPTScreen(91), ScreenW, FitPTScreen(91))];
    footView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:footView];
    // 加按钮
    UIButton *saveButton = [[UIButton alloc] init];
    [footView addSubview:saveButton];
    [saveButton setTitle:_isAdd?@"添加打印机":@"保存" forState:UIControlStateNormal];
    saveButton.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(15)];
    [saveButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [saveButton setBackgroundImage:[UIImage imageNamed:@"voucher_bottom_btn"] forState:UIControlStateNormal];
    [saveButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(FitPTScreen(0));
        make.width.equalTo(FitPTScreen(307));
        make.height.equalTo(FitPTScreen(72));
    }];
    [saveButton addTarget:self action:@selector(bottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)initSubViews{
    _scrollView = [[UIScrollView alloc]init];
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.backgroundColor = UIColorFromRGB(0xFAFAFA);
    _scrollView.contentSize = CGSizeMake(ScreenW, ScreenH);
    _scrollView.bounces = YES;
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    [_scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(self.view);
        make.top.equalTo(Height_NavBar);
        make.height.equalTo(ScreenH - Height_NavBar - FitPTScreen(118));
    }];
    
    UIView * printerView = [[UIView alloc]initWithFrame:CGRectMake(0, FitPTScreen(15), ScreenW, FitPTScreen(45))];
    printerView.backgroundColor = UIColor.whiteColor;
    [_scrollView addSubview:printerView];
    printerView.backgroundColor = UIColor.whiteColor;
    [printerView addSubview:[HLTools lineWithGap:0 topMargn:0]];
    [printerView addSubview:[HLTools lineWithGap:0 topMargn:FitPTScreen(44)]];
    
    UILabel * lable = [[UILabel alloc]init];
    lable.font = [UIFont systemFontOfSize:FitPTScreen(15)];
    lable.textColor = UIColorFromRGB(0x656565);
    lable.text = @"开启打印机";
    [printerView addSubview:lable];
    [lable makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(20));
        make.centerY.equalTo(printerView);
        
    }];
    
    _switchView = [[UISwitch alloc]init];
    _switchView.tintColor = [UIColor clearColor];
    _switchView.onTintColor = UIColorFromRGB(0xFF8D26);
    [_switchView setBackgroundColor:UIColorFromRGB(0xFFF2F2F2)];
    _switchView.layer.cornerRadius = _switchView.bounds.size.height/2.0;
    _switchView.on = YES;
    [self.pargram setValue:@(_switchView.on) forKey:@"is_print"];
    [printerView addSubview:_switchView];
    
    [_switchView addTarget:self action:@selector(changeValue:) forControlEvents:UIControlEventValueChanged];
    
    [_switchView makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(FitPTScreen(-20));
        make.centerY.equalTo(printerView);
    }];
    
    UIView * textBagView = [[UIView alloc]init];
    textBagView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:textBagView];
    [textBagView makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(self.scrollView);
        make.top.equalTo(printerView.mas_bottom).offset(FitPTScreen(15));
        make.height.equalTo(FitPTScreen(45));
    }];
    [textBagView addSubview:[HLTools lineWithGap:0 topMargn:0]];
    
    _textField = [[UITextField alloc]init];
    _textField.backgroundColor = UIColor.whiteColor;
    _textField.delegate = self;
    _textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"小票标题  最多支持10个汉字" attributes:@{NSForegroundColorAttributeName: UIColorFromRGB(0xCACACA),NSFontAttributeName:[UIFont systemFontOfSize:FitPTScreen(14)]}];
    [textBagView addSubview:_textField];
    
    [_textField makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(20));
        make.right.equalTo(FitPTScreen(-20));
        make.height.equalTo(FitPTScreen(43));
        make.top.equalTo(textBagView).offset(FitPTScreen(2));
    }];
    _textFieldtool = [[HLTextFieldCheckInputNumberTool alloc]init];
    _textFieldtool.MAX_STARWORDS_LENGTH = 10;
    [_textField addTarget:_textFieldtool action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
    
    UIView * textViewBag = [[UIView alloc]init];
    textViewBag.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:textViewBag];
    [textViewBag makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(self.scrollView);
        make.top.equalTo(self.textField.mas_bottom);
        make.height.equalTo(FitPTScreen(190));
    }];
    
    _textView = [[UITextView alloc]initWithFrame:CGRectZero];
    _textView.zw_placeHolder = @"商家备注  最多支持700个汉字";
    _textView.zw_placeHolderColor = UIColorFromRGB(0xCACACA);
    _textView.font = [UIFont systemFontOfSize:FitPTScreen(14)];
    _textView.showsVerticalScrollIndicator = NO;
    _textView.delegate = self;
    [textViewBag addSubview:_textView];
    [_textView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(FitPTScreen(15));
        make.right.equalTo(FitPTScreen(-15));
        make.top.height.equalTo(textViewBag);
    }];
    [textViewBag addSubview:[HLTools lineWithGap:FitPTScreen(10) topMargn:0]];
    
    _textViewtool = [[HLTextFieldCheckInputNumberTool alloc]init];
    _textViewtool.MAX_STARWORDS_LENGTH = 700;
    [[NSNotificationCenter defaultCenter] addObserver:_textViewtool selector:@selector(textViewDidChangeText:) name:UITextViewTextDidChangeNotification object:_textView];
    
}

#pragma mark - Method
-(void)changeValue:(UISwitch *)sender{
    [self.pargram setValue:@(sender.on) forKey:@"is_print"];
}

- (void)bottomBtnClick:(UIButton *)sender {
    
    if (![_textField.text hl_isAvailable]) {
        return;
    }
    if (_isAdd) {
        [self loadData];
        return;
    }
    [self loadDataWithType:4];
}

#pragma mark - Request
//添加打印机
-(void)loadData{
    NSDictionary * pargram = @{
        @"store_id":_storeID?:@"",
    };
    [self.pargram addEntriesFromDictionary:pargram];
    
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/MerchantSide/PrinterAdd.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = self.pargram;
    } onSuccess:^(id responseObject) {
        HLHideLoading(self.view);
        XMResult * result = (XMResult *)responseObject;
        if (result.code == 200) {
            [self handleAddPrinterData];
        }
    } onFailure:^(NSError *error) {
        HLHideLoading(self.view);
    }];
}

-(void)handleAddPrinterData{
    //发送通知 刷新添加打印机页面
    [[NSNotificationCenter defaultCenter]postNotificationName:HLAddPrinterSuccessNotifi object:nil];
    //刷新我的页面
    [[NSNotificationCenter defaultCenter]postNotificationName:HLReloadMineDataNotifi object:nil];
    
    NSMutableArray * controllers = self.navigationController.viewControllers.mutableCopy;
    if (controllers.count == 4) {
        [controllers removeObjectAtIndex:2];
    }
    self.navigationController.viewControllers = controllers;
    [self hl_goback];
}

//打印机内容设置里面3.获取默认值 4.保存
-(void)loadDataWithType:(NSInteger)type{
    NSDictionary * pargram = @{
        @"type":@(type),
        @"store_id":_storeID,
        @"pid":_printerInfo[@"id"],
    };
    
    [self.pargram addEntriesFromDictionary:pargram];
    
    
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/MerchantSide/PrinterEdit.php";
        request.serverType = HLServerTypeNormal;
        request.parameters = self.pargram;
    } onSuccess:^(id responseObject) {
        HLHideLoading(self.view);
        XMResult * result = (XMResult *)responseObject;
        if (result.code == 200) {
            NSArray * datas = result.data;
            [self handlePrinterWithType:type data:datas];
        }
    } onFailure:^(NSError *error) {
        HLHideLoading(self.view);
    }];
}

-(void)handlePrinterWithType:(NSInteger)type data:(NSArray *)datas{
    if (!datas.count) {
        if (type == 4) {
            [HLTools showWithText:@"保存成功"];
            if (self.callBack) {
                self.callBack(_switchView.on);
            }
            
            [[NSNotificationCenter defaultCenter]postNotificationName:HLAddPrinterSuccessNotifi object:nil];
            //刷新我的页面
            [[NSNotificationCenter defaultCenter]postNotificationName:HLReloadMineDataNotifi object:nil];
            
            [self hl_goback];
        }
        return;
    }
    
    NSDictionary * data = datas[0];
    _switchView.on = [data[@"is_print"] integerValue] == 1;
    _textField.text = data[@"printer_title"]?:@"";
    _textView.text = data[@"remarks"]?:@"";
    
    NSArray * custom_info = data[@"custom_info"];
    NSString * custom_str = [custom_info mj_JSONString];
    //给buttonsView赋值
    [_buttonsView setSelectWithArray:custom_info];
    //给pargram赋值
    [self.pargram setValuesForKeysWithDictionary:data];
    [self.pargram setValue:custom_str forKey:@"custom_info"];
}


#pragma mark - HLButtonsViewDelegate
-(void)buttonsView:(HLButtonsView *)view selectArray:(NSArray *)arr{
    [self.pargram setValue:[arr mj_JSONString] forKey:@"custom_info"];
}

#pragma mark - UITextFieldDelegate
-(void)textFieldDidEndEditing:(UITextField *)textField{
    [self.pargram setValue:textField.text forKey:@"printer_title"];
}

#pragma mark - UITextViewDelegate
-(void)textViewDidEndEditing:(UITextView *)textView{
    [self.pargram setValue:textView.text forKey:@"remarks"];
}

- (NSMutableDictionary *)pargram {
    if (!_pargram) {
        _pargram = [NSMutableDictionary dictionary];
        [_pargram setValue:@"" forKey:@"custom_info"];
        [_pargram setValue:@"" forKey:@"printer_title"];
        [_pargram setValue:@"" forKey:@"remarks"];
    }
    return _pargram;
}

@end
