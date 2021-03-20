//
//  HLAlertController.m
//  HuiLife
//
//  Created by 雷清华 on 2019/8/9.
//

#import "HLAlertController.h"


@interface HLAlertController ()

@property(nonatomic,strong)UIView * alertView;

@property(nonatomic,assign)CGFloat alertViewH;

@property(nonatomic,strong)NSArray<HLAlertAction*> * actions;

@end

@implementation HLAlertController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:false];
    [self showAnimate];
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

-(instancetype)init{
    if (self = [super init]) {
        _alertWidth = FitPTScreen(286);
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.clearColor;
    self.modalPresentationStyle = UIModalPresentationCustom;
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.0];
}


-(void)addActions:(NSArray<HLAlertAction *> *)actions{
    
    _actions = actions;
    //    是否有设置取消按钮，只能设置一个
    __block HLAlertAction * cancelAction;
    __block totalHight = 0.0;
    [actions enumerateObjectsUsingBlock:^(HLAlertAction * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.type == HLAlertActionCancel) {
            cancelAction = obj;
        }
        totalHight += obj.hight;
    }];
    
    if (!cancelAction) {
        totalHight += FitPTScreen(50);
    }
    
    _alertViewH = totalHight + FitPTScreen(30);
    _alertView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenH, ScreenW,_alertViewH)];
    _alertView.backgroundColor = UIColor.clearColor;
    [self.view addSubview:_alertView];
    
    UIView * normalBtnView = [[UIView alloc]init];
    normalBtnView.backgroundColor = UIColor.whiteColor;
    normalBtnView.layer.cornerRadius = FitPTScreen(7);
    normalBtnView.layer.masksToBounds = YES;
    [_alertView addSubview:normalBtnView];
    [normalBtnView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.alertView);
        make.centerX.equalTo(self.alertView);
        make.width.equalTo(_alertWidth);
    }];
    
    __block CGFloat topMargen = 0;
    [actions enumerateObjectsUsingBlock:^(HLAlertAction * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.type != HLAlertActionCancel) {
            UIButton * button = [[UIButton alloc]init];
            button.tag = idx;
            [button setTitle:obj.title forState:UIControlStateNormal];
            [button setTitleColor:obj.tintColor forState:UIControlStateNormal];
            button.titleLabel.font = obj.font;
            [normalBtnView addSubview:button];
            [button makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(topMargen);
                make.left.width.equalTo(normalBtnView);
                make.height.equalTo(obj.hight);
                if (idx == actions.count-1) {
                    make.bottom.equalTo(normalBtnView);
                }
            }];
            [button addTarget:self action:@selector(functionClick:) forControlEvents:UIControlEventTouchUpInside];
            
            topMargen += obj.hight;
            if (obj.showLine) {
                UIView * line = [[UIView alloc]init];
                line.backgroundColor = UIColorFromRGB(0xB7BEC8);
                [button addSubview:line];
                [line makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(FitPTScreen(15));
                    make.right.equalTo(FitPTScreen(-15));
                    make.bottom.equalTo(button);
                    make.height.equalTo(FitPTScreen(0.7));
                }];
            }
            
        }
    }];
    
    UIButton * cancelBtn = [[UIButton alloc]init];
    cancelBtn.backgroundColor = UIColor.whiteColor;
    cancelBtn.layer.cornerRadius = FitPTScreen(7);
    [cancelBtn setTitle:cancelAction.title?:@"返回" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:cancelAction.tintColor?:UIColorFromRGB(0x222222) forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = cancelAction.font?:[UIFont systemFontOfSize:FitPTScreen(14)];
    [_alertView addSubview:cancelBtn];
    [cancelBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(normalBtnView.bottom).offset(FitPTScreen(10));
        make.left.width.equalTo(normalBtnView);
        make.height.equalTo(cancelAction.hight?:FitPTScreen(50));
    }];
    [cancelBtn addTarget:self action:@selector(cancelClick:) forControlEvents:UIControlEventTouchUpInside];
    
}


-(void)cancelClick:(UIButton *)sender{
    [self hideAnimate];
}

-(void)functionClick:(UIButton *)sender{
    HLAlertAction * action = _actions[sender.tag];
    if (action.completion) {
        action.completion();
    }
    [self hideAnimate];
}

-(void)showAnimate{
    [UIView animateWithDuration:0.3 animations:^{
        self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        CGRect frame = self.alertView.frame;
        frame.origin.y = ScreenH -self.alertViewH;
        self.alertView.frame = frame;
    }];
}

-(void)hideAnimate{
    [UIView animateWithDuration:0.3 animations:^{
        self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        CGRect frame = self.alertView.frame;
        frame.origin.y = ScreenH;
        self.alertView.frame = frame;
    } completion:^(BOOL finished) {
        [self.alertView removeFromSuperview];
        [self dismissViewControllerAnimated:false completion:nil];
    }];
}

@end
