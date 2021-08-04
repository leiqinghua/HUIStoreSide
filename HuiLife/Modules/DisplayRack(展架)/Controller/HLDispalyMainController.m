//
//  HLDispalyMainController.m
//  HuiLife
//
//  Created by 雷清华 on 2019/11/25.
//

#import "HLDispalyMainController.h"
#import "HLDisplayTitleView.h"
#import "HLDisplaySubController.h"
#import "HLDisplayWebController.h"
#import "HLDisplayModel.h"

@interface HLDispalyMainController () <UIScrollViewDelegate, HLDisplayTitleViewDelegate, HLDisplaySubControllerDelegate>

@property(nonatomic, strong)HLDisplayTitleView *titleView;

@property(nonatomic, strong)UIScrollView *mainScrollView;

@property(nonatomic, strong)NSMutableArray *subControllers;

@property(nonatomic, strong)NSArray *types;//分类

@property(nonatomic, strong)NSArray *typeTexts;//分类标题

@end

@implementation HLDispalyMainController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self hl_setTitle:@"展架模板"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
//    请求展架分类数据
    [self loadDisplayTypeDatas];
}

- (void)initSubView {
    _titleView = [[HLDisplayTitleView alloc]initWithFrame:CGRectMake(0,Height_NavBar, ScreenW, FitPTScreen(52))];
    _titleView.titles = _typeTexts;
    _titleView.delegate = self;
    [self.view addSubview:_titleView];
    
    _mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_titleView.frame), ScreenW, ScreenH -CGRectGetMaxY(_titleView.frame))];
    _mainScrollView.delegate = self;
    _mainScrollView.showsHorizontalScrollIndicator = false;
    _mainScrollView.contentSize = CGSizeMake(ScreenW * _typeTexts.count, 0);
    _mainScrollView.pagingEnabled = YES;
    [self.view addSubview:_mainScrollView];
    
    [_titleView clickWithIndex:0];
}

#pragma makr - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = scrollView.contentOffset.x / ScreenW;
    [_titleView clickWithIndex:index];
}

#pragma mark - HLDisplayTitleViewDelegate

- (void)displayView:(HLDisplayTitleView *)displayView selectAtIndex:(NSInteger)index {
    if (self.subControllers.count < index + 1) {
        HLDisplaySubController *subVC = [[HLDisplaySubController alloc]init];
        subVC.delegate = self;
        [self addChildViewController:subVC];
        
        subVC.view.frame = CGRectMake(index * ScreenW, 0, ScreenW, CGRectGetMaxY(self.mainScrollView.bounds));
        [self.mainScrollView addSubview:subVC.view];
        [subVC resetFrame];
        
        [self.subControllers addObject:subVC];
        
        NSDictionary *typeDict = self.types[index];
        [subVC loadListWithClassId:typeDict[@"class_id"] type:_type proId:_pro_id];
        
    }
    
    [self.mainScrollView setContentOffset:CGPointMake(ScreenW * index, 0) animated:false];
}

#pragma mark - HLDisplaySubControllerDelegate
- (void)displayController:(HLDisplaySubController *)controller selectModel:(HLDisplayModel *)model {
    HLDisplayWebController *webVC = [[HLDisplayWebController alloc]init];
    webVC.dl_url = model.dl_url;
    webVC.loadUrl = model.url;
    [self hl_pushToController:webVC];
}

#pragma mark - getter
- (NSMutableArray *)subControllers {
    if (!_subControllers) {
        _subControllers = [NSMutableArray array];
    }
    return _subControllers;
}

#pragma mark - 请求分类

-(void)loadDisplayTypeDatas{
    HLLoading(self.view);
    [XMCenter sendRequest:^(XMRequest *request) {
        request.api = @"/Shopplus/Zhanjia/class";
        request.serverType = HLServerTypeStoreService;
        request.parameters = @{};
    } onSuccess:^(id responseObject) {
        HLHideLoading(self.view);
        XMResult * result = (XMResult *)responseObject;
        if (result.code == 200) {
            self.types = result.data;
            NSMutableArray *texts = [NSMutableArray array];
            for (NSDictionary *dict in self.types) {
                [texts addObject:dict[@"class_name"]];
            }
            self.typeTexts = [texts copy];
            [self initSubView];
        }
        
    } onFailure:^(NSError *error) {
        HLHideLoading(self.view);
    }];
}

@end
