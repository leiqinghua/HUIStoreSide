//
//  HLServiceDescripController.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/7/23.
//

#import "HLServiceDescripController.h"


@interface HLServiceDescripController ()<UITextViewDelegate>{
    UIButton *addBtn;
    UITextView * textview;
}
@end

@implementation HLServiceDescripController

-(void)viewWillAppear:(BOOL)animated{
    [self hl_setTitle:_isService?@"服务说明":@"拒绝原因" andTitleColor:[UIColor whiteColor]];
    self.navigationItem.hidesBackButton = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(0xF2F2F2);
    UIButton *cancel = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 20)];
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    [cancel setTitleColor:UIColorFromRGB(0xFFFFFF) forState:UIControlStateNormal];
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc]initWithCustomView:cancel];
    [cancel addTarget:self action:@selector(cancelClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = leftBar;
    
    addBtn = [[UIButton alloc]init];
    [addBtn setTitle:@"提交" forState:UIControlStateNormal];
    [addBtn setTitleColor:UIColorFromRGB(0xFFFFFF) forState:UIControlStateNormal];
    addBtn.backgroundColor = UIColorFromRGB(0xFF8D26);
    addBtn.titleLabel.font=[UIFont systemFontOfSize:FitPTScreen(15)];
    [self.view addSubview:addBtn];
    [addBtn addTarget:self action:@selector(addYG:) forControlEvents:UIControlEventTouchUpInside];
    [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.left.bottom.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-Height_Bottom_Margn);
        make.height.equalTo(FitPTScreen(44));
    }];
    
    UIView * bottomView = [[UIView alloc]init];
    bottomView.backgroundColor = [UIColor whiteColor];
    bottomView.layer.cornerRadius = 5;
    bottomView.layer.shadowColor =[UIColor blackColor].CGColor;
    bottomView.layer.shadowRadius = 5;
    bottomView.layer.shadowOpacity = 0.8f;
    bottomView.layer.masksToBounds = YES;
    bottomView.layer.shadowOffset = CGSizeMake(4, 4);
    
    [self.view addSubview:bottomView];
    [bottomView makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(IS_IPHONE_X?104:80);
        make.width.equalTo(FitPTScreen(335));
        make.height.equalTo(FitPTScreen(200));
    }];
    
    UILabel * lable = [[UILabel alloc]init];
    lable.text = _isService?@"服务说明":@"拒绝原因";
    lable.font = [UIFont fontWithName:@"MicrosoftYaHei-Bold" size:14];
    [bottomView addSubview:lable];
    [lable makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomView).offset(FitPTScreen(20));
        make.left.equalTo(bottomView).offset(FitPTScreen(16));
    }];

    UIView *lineview = [[UIView alloc]init];
    lineview.backgroundColor = UIColorFromRGB(0xDDDDDD);
    [bottomView addSubview:lineview];
    [lineview makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomView).offset(FitPTScreen(52));
        make.left.width.equalTo(bottomView);
        make.height.equalTo(1);
    }];

    textview = [[UITextView alloc]init];
    if (_model) {
        textview.text = _model.value;
    }
    textview.zw_placeHolder = _isService?@"请输入服务说明":@"请填写拒绝退款的原因";
    textview.zw_placeHolderColor = UIColorFromRGB(0x656565);
    textview.delegate = self;
    [bottomView addSubview:textview];
    [textview makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineview.mas_bottom);
        make.left.bottom.width.equalTo(bottomView);
    }];
    
}

-(void)addYG:(UIButton *)sender{
    if (_isService) {
        NSString *text = @"";
        if (textview.text.length >15) {
            text = [NSString stringWithFormat:@"%@...",[textview.text substringToIndex:15]];
        }else{
            text = textview.text;
        }
        if (self.descBlock) {
            self.descBlock(textview.text, text);
        }
        [self hl_goback];
    }

}

-(void)cancelClick:(UIButton *)sender{
    [self hl_goback];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


@end
