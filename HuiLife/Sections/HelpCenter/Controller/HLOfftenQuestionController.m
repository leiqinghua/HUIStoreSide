//
//  HLOfftenQuestionController.m
//  HuiLife
//
//  Created by 雷清华 on 2019/10/17.
//

#import "HLOfftenQuestionController.h"

@interface HLOfftenQuestionController ()

@property(nonatomic, assign) BOOL loaded;

@end

@implementation HLOfftenQuestionController

- (void)viewWillAppear:(BOOL)animated{
    
}

- (void)resetFrame {
    self.webview.frame = self.view.bounds;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webview.backgroundColor = UIColor.purpleColor;
    [self setProgressFrame:CGRectMake(0, 0, ScreenW, FitPTScreen(3))];
}

- (void)setLoadUrl:(NSString *)loadUrl {
    if (_loaded) return;
    [super setLoadUrl:loadUrl];
    _loaded = YES;
}

@end
