//
//  HLSelectShowView.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/7/19.
//

#import "HLSelectShowView.h"
#import "HLSelectShowViewCell.h"
#import "HLSelectTimeCell.h"
#import "JYEqualCellSpaceFlowLayout.h"
#import "HLTextFieldViewCell.h"
//#import "QFTimePickerView.h"

/*
 待优化。。。selectItems 应为所选的数据源
 */
@interface HLSelectShowView()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIGestureRecognizerDelegate>
@property(strong,nonatomic)UICollectionView *collectionView;

@property(assign,nonatomic)CGRect originFrame;

@property(copy,nonatomic)NSString * beginText;

@property(copy,nonatomic)NSString * endText;

@property(strong,nonatomic)UITextField * textField;
//所有出现过的index
@property(strong,nonatomic)NSMutableArray * allShowedIndexs;

@property(strong,nonatomic)NSMutableArray * dataFrames;

@property(assign,nonatomic)BOOL isReload;

@property(strong,nonatomic)UIButton *cancel;

@property(strong,nonatomic)UIButton *concern;
@end
@implementation HLSelectShowView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self= [super initWithFrame:frame]) {
        [self createUI];
        _timeAtSection = -1;
        _sigleSection = -1;
        _textfieldSection = -1;
        _originFrame = frame;
    }
    return self;
}

-(instancetype)init{
    if (self= [super init]) {
        [self createUI];
        _timeAtSection = -1;
        _sigleSection = -1;
        _textfieldSection = -1;
    }
    return self;
}

- (void)createUI {
    self.backgroundColor = [UIColor whiteColor];
    JYEqualCellSpaceFlowLayout * flowLayout = [[JYEqualCellSpaceFlowLayout alloc]initWithType:AlignWithLeft betweenOfCell:21];
    //设置headerview尺寸大小
    flowLayout.headerReferenceSize = CGSizeMake(ScreenW, FitPTScreen(51));
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.minimumLineSpacing = FitPTScreen(16);
    flowLayout.minimumInteritemSpacing = FitPTScreen(21);
    /*
     此情况下这句话一定不能写，不然会造成死循环(至于为啥还没研究...)
     flowLayout.estimatedItemSize = CGSizeMake(ScreenW, FitPTScreen(29));
     */
    //CGRectMake(26, 0, self.bounds.size.width-52, self.bounds.size.height-FitPTScreen(44))
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = UIColorFromRGB(0xF5F5F5);
    //注册cell
    [_collectionView registerClass:[HLSelectShowViewCell class] forCellWithReuseIdentifier:@"cellID"];
    [_collectionView registerClass:[HLSelectTimeCell class] forCellWithReuseIdentifier:@"HLSelectTimeCell"];
    [_collectionView registerClass:[HLTextFieldViewCell class] forCellWithReuseIdentifier:@"HLTextFieldViewCell"];
    //注册headerView
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reusableView"];
    _collectionView.dataSource =self;
    _collectionView.delegate = self;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_collectionView];
    
    _cancel = [[UIButton alloc]init];
    [_cancel setTitle:@"取消" forState:UIControlStateNormal];
    _cancel.layer.borderColor =UIColorFromRGB(0xFF8D26).CGColor;
    _cancel.layer.borderWidth = 0.5;
    [_cancel setTitleColor:UIColorFromRGB(0xFF8D26) forState:UIControlStateNormal];
    [self addSubview:_cancel];
    [_cancel addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    
    _concern = [[UIButton alloc]init];
    [_concern setTitle:@"确认" forState:UIControlStateNormal];
    [_concern setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _concern.backgroundColor = UIColorFromRGB(0xFF8D26);
    [self addSubview:_concern];
    [_concern addTarget:self action:@selector(concern:) forControlEvents:UIControlEventTouchUpInside];
    
    [_collectionView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(26);
        make.width.top.equalTo(self);
    }];
    [self layoutBtn];
    
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    tap.delegate = self;
    [_collectionView addGestureRecognizer:tap];
    
}

-(void)layoutBtn{
    [_cancel remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.collectionView.mas_bottom).offset(FitPTScreen(10));
        make.left.bottom.equalTo(self);
        make.width.equalTo(self.bounds.size.width/2);
        make.height.equalTo(FitPTScreen(44));
    }];
    
    [_concern remakeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self);
        make.width.equalTo(self.bounds.size.width/2);
        make.height.equalTo(FitPTScreen(44));
    }];
}

-(void)cancel:(UIButton *)sender{
    NSLog(@"点击取消");
    self.hidden = YES;
    if (self.delegate) {
        [self.delegate cancelBtn:sender];
    }
}

-(void)concern:(UIButton *)sender{
    NSLog(@"点击确认");
    if ([self.delegate respondsToSelector:@selector(concernBtn:selectItems:begin:end:)]) {
        [self.delegate concernBtn:sender selectItems:self.selectItems begin:_beginText end:_endText];
    }if ([self.delegate respondsToSelector:@selector(concernBtn:selectItems:)]) {
        [self.delegate concernBtn:sender selectItems:self.selectItems];
    }if ([self.delegate respondsToSelector:@selector(concernBtnWihtselectItems:IsOrders:begin:end:memberNum:)]) {
        [self.delegate concernBtnWihtselectItems:self.selectItems IsOrders:_isAllOrders begin:_beginText end:_endText memberNum:_textField?_textField.text:@""];
    }if ([self.delegate respondsToSelector:@selector(openBtnSelected:)]) {
        [self.delegate openBtnSelected:_openBtn.selected];
    }
}
-(NSMutableArray *)selectItems{
    if (!_selectItems) {
        _selectItems = [[NSMutableArray alloc]init];
    }
    return  _selectItems;
}

-(NSMutableArray *)allShowedIndexs{
    if (!_allShowedIndexs) {
        _allShowedIndexs = [NSMutableArray array];
    }
    return _allShowedIndexs;
}

-(NSMutableArray *)dataFrames{
    if (!_dataFrames) {
        _dataFrames = [NSMutableArray array];
    }
    return _dataFrames;
}

-(void)setDataSource:(NSMutableArray *)dataSource{
    _dataSource = dataSource;
    for (int i=0; i<dataSource.count; i++) {
        //缓存大小
        if ((i != _timeAtSection) && (i!= _textfieldSection)) {
            NSDictionary *dict = self.dataSource[i];
            NSArray *datas = (NSArray*)dict[@"datas"];
            for (int j=0; j<datas.count; j++) {
                NSString *text;
                if (_type == HLMDManagerListType) {
                    text = [NSString stringWithFormat:@"%@",datas[j][@"classname"]];;
                }else if(_type == HLYGManagerListType){
                    text = datas[j][@"name"];
                }else if (_type == HLMDInfoSettingType){
                    text = datas[j];
                }else if (_type == HLOrderListType){
                    text = datas[j][@"name"];
                }
                CGRect frame = [self estamateFrameWithSize:CGSizeMake(CGFLOAT_MAX,FitPTScreen(30)) text:text];
                if (frame.size.width <=FitPTScreen(85)) {
                    frame.size.width = FitPTScreen(85);
                }else{
                    frame.size.width += 40;
                }
                if (frame.size.width > ScreenW - 52) {
                    frame = [self estamateFrameWithSize:CGSizeMake(ScreenW - 52 - 40,CGFLOAT_MAX) text:text];
                }if (frame.size.height <= FitPTScreen(12) ) {
                    frame.size.height = FitPTScreen(30);
                }else{
                    frame.size.height += FitPTScreen(18);
                }
                [self.dataFrames addObject:[NSValue valueWithCGRect:frame]];
            }
            weakify(self);
            [_collectionView reloadData];
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"contentSize = %@",NSStringFromCGSize(self.collectionView.collectionViewLayout.collectionViewContentSize));
                CGFloat hight = self.collectionView.collectionViewLayout.collectionViewContentSize.height;
                if (hight + FitPTScreen(54)> self.max_hight) {
                    hight = self.max_hight - FitPTScreen(54);
                    if (IS_IPHONE_X) {
                        hight -= 34;
                    }
                }
                [weak_self.collectionView updateConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(hight);
                }];
                [weak_self layoutBtn];
                [weak_self setNeedsUpdateConstraints];
                [weak_self updateConstraintsIfNeeded];
            });
        }
    }
}

-(CGRect)estamateFrameWithSize:(CGSize)size text:(NSString *)text{
    CGRect frame = [[NSString stringWithFormat:@"%@",text] boundingRectWithSize:size options:(NSStringDrawingTruncatesLastVisibleLine|   NSStringDrawingUsesFontLeading |NSStringDrawingUsesLineFragmentOrigin) attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:12],NSFontAttributeName, nil] context:nil];
    return frame;
}

-(void)setBeginAndEnd:(NSArray *)beginAndEnd{
    _beginAndEnd = beginAndEnd;
    if (_beginAndEnd.count > 0) {
        _beginText = _beginAndEnd.firstObject;
        _endText = _beginAndEnd.lastObject;
    }
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.dataSource?self.dataSource.count:0;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSDictionary *dict = self.dataSource[section];
    NSArray *datas = (NSArray*)dict[@"datas"];
    if (_type == HLOrderListType && section == 3) {
        if (datas.count > 3 && !_isOpen) {
            return 3;
        }
    }
    return datas.count ;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == _timeAtSection) {
        //HLSelectTimeCell
        HLSelectTimeCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HLSelectTimeCell" forIndexPath:indexPath];
        if (self.timetitles || self.timetitles.count !=0) {
            cell.begin.text = self.timetitles.firstObject;
            cell.end.text = self.timetitles.lastObject;
        }
        if ([_beginText hl_isAvailable]) {
            cell.begin.text = _beginText;
        }
        if ([_endText hl_isAvailable]) {
            cell.end.text = _endText;
        }
        UITapGestureRecognizer * begin = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(beginClick:)];
        [cell.begin addGestureRecognizer:begin];
        cell.begin.tag = 10000;
        UITapGestureRecognizer * end = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(beginClick:)];
        [cell.end addGestureRecognizer:end];
        cell.end.tag = 10001;
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadTime:) name:HLReloadShowTimeNotifi object:nil];
        return cell;
    }else if (indexPath.section == _textfieldSection){
        HLTextFieldViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HLTextFieldViewCell" forIndexPath:indexPath];
        self.textField = cell.textfield;
        self.textField.text = _memberText?:@"";
        return cell;
    }
    HLSelectShowViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellID" forIndexPath:indexPath];
    if (![self.allShowedIndexs containsObject:indexPath]) {
        [self.allShowedIndexs addObject:indexPath];
    }
    [cell setUIDefault:YES];
    for (NSIndexPath* index in self.selectItems) {
        if (index.section == indexPath.section && index.row == indexPath.row) {
            [cell setUIDefault:NO];
        }
    }
    NSDictionary *dict = self.dataSource[indexPath.section];
    NSArray *datas = (NSArray*)dict[@"datas"];
    if (_type == HLMDManagerListType) {
        cell.title.text = [NSString stringWithFormat:@"%@",datas[indexPath.row][@"classname"]];
    }else if (_type == HLYGManagerListType){
        cell.title.text = datas[indexPath.row][@"name"];
    }else if (_type == HLMDInfoSettingType){
        cell.title.text = datas[indexPath.row];
    }else if (_type == HLOrderListType){
        cell.title.text = datas[indexPath.row][@"name"];
    }
    return cell;
}



- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == _timeAtSection ) {
        return CGSizeMake(ScreenW, FitPTScreen(31));
    }else if(indexPath.section == _textfieldSection){
        return CGSizeMake(ScreenW, FitPTScreen(31));
    }
    if (self.dataFrames.count > 0) {
        NSValue * value = self.dataFrames[indexPath.row];
        return [value CGRectValue].size;
    }
    return CGSizeZero;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView * headerView = [_collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"reusableView" forIndexPath:indexPath];
        for (UIView *subview in headerView.subviews) {
            [subview removeFromSuperview];
        }
        UILabel *title = [[UILabel alloc]init];
        title.textAlignment = NSTextAlignmentLeft;
        title.font = [UIFont systemFontOfSize:FitPTScreen(15)];
        title.textColor = UIColorFromRGB(0x656565);
        title.layer.cornerRadius = 4;
        [headerView addSubview:title];
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.left.equalTo(headerView);
        }];
        NSDictionary *dict = self.dataSource[indexPath.section];
        title.text = dict[@"title"];
//        if (!_openBtn) {
            _openBtn = [[UIButton alloc]init];
            [headerView addSubview:_openBtn];
            [_openBtn setTitle:@"展开" forState:UIControlStateNormal];
            [_openBtn setTitle:@"收起" forState:UIControlStateSelected];
            [_openBtn setTitleColor:UIColorFromRGB(0x989898) forState:UIControlStateNormal];
            [_openBtn setImage:[UIImage imageNamed:@"arrow_down_grey_light"] forState:UIControlStateNormal];
            [_openBtn setImage:[UIImage imageNamed:@"arrow_up_grey"] forState:UIControlStateSelected];
            _openBtn.titleLabel.font = [UIFont systemFontOfSize:FitPTScreen(13)];
            // button标题的偏移量
            [_openBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, - _openBtn.imageView.image.size.width-10, 0, _openBtn.imageView.image.size.width+10)];
            [_openBtn setImageEdgeInsets:UIEdgeInsetsMake(0, _openBtn.titleLabel.bounds.size.width+10, 0, -_openBtn.titleLabel.bounds.size.width-10)];
            [_openBtn addTarget:self action:@selector(openAndClose:) forControlEvents:UIControlEventTouchUpInside];
            [_openBtn makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(headerView);
                make.right.equalTo(self).offset(FitPTScreen(-20));
                make.width.equalTo(FitPTScreen(120));
                make.height.equalTo(FitPTScreen(40));
            }];
//        }
        _openBtn.selected = _isOpen;
        if (_isShowOpenBtn && indexPath.section == 3 && ((NSArray *)dict[@"datas"]).count >3 ) {
            _openBtn.hidden = NO;
        }else{
            [_openBtn removeFromSuperview];
            _openBtn = nil;
        }
        NSLog(@"这是第%ld个headerview",indexPath.section);
        return headerView;
    }
    return nil;
}

-(void)openAndClose:(UIButton *)sender{
    sender.selected = !sender.selected;
    _isOpen = sender.selected;
    [self.collectionView reloadData];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    NSDictionary *dict = self.dataSource[section];
    if ([dict[@"title"] isEqualToString:@""]) {
        return  CGSizeMake(ScreenW, FitPTScreen(30));
    }
    return  CGSizeMake(ScreenW, FitPTScreen(51));
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == _timeAtSection){
        return;
    }
    NSIndexPath * index = [NSIndexPath indexPathForRow:0 inSection:indexPath.section];
    for (NSIndexPath * path in self.allShowedIndexs) {
        if (path.section == index.section && path.row == index.row) {
            index = path;
            break;
        }
    }
    NSDictionary *dict = self.dataSource[indexPath.section];
    NSArray * arr = dict[@"datas"];
    
    NSMutableArray * selects = [NSMutableArray arrayWithArray:self.selectItems];
    if (![selects containsObject:indexPath]) {
        [self.selectItems addObject:indexPath];
        //判断当前section第0个是否存在，如果存在就删除
        if ([selects containsObject:index]) {
            [self.selectItems removeObject:index];
        }
    }else{
        [self.selectItems removeObject:indexPath];
//        if (indexPath.row !=0) {
//            [self.selectItems removeObject:indexPath];
//        }
    }
    if (indexPath.row == 0 && [self.selectItems containsObject:index]) {
        //        [self.selectItems addObject:index];
        //移除掉这个分组的其他cell
        for (int i=1; i<arr.count; i++) {
            NSIndexPath * indexpath = [NSIndexPath indexPathForRow:i inSection:indexPath.section];
            for (NSIndexPath * path in self.allShowedIndexs) {
                if (path.section == indexpath.section && path.row == indexpath.row) {
                    indexpath = path;
                    break;
                }
            }
            if ([self.selectItems containsObject:indexpath]) {
                [self.selectItems removeObject:indexpath];
            }
        }
    }
    MJWeakSelf;
    if (indexPath.section == _sigleSection) {
        for (NSIndexPath * path in self.selectItems.reverseObjectEnumerator) {
            if (path.section == weakSelf.sigleSection) {
                [self.selectItems removeObject:path];
            }
        }
        [self.selectItems addObject:indexPath];
    }
    if ((_type == HLMDManagerListType&&indexPath.section == 0) || (_type == HLOrderListType && indexPath.section == 2)) {
        if (self.delegate) {
            [self.delegate selectFirstSectionWithItem:arr[indexPath.row]];
        }
    }else{
        [collectionView reloadData];
    }
}

-(void)reloadViews{
    [self.collectionView reloadData];
}


-(void)beginClick:(UITapGestureRecognizer *)tap{
    UILabel * lable =(UILabel*)tap.view;
    if ([self.delegate respondsToSelector:@selector(didSelectTimeWithTag:)]) {
        [self.delegate didSelectTimeWithTag:lable.tag];
    }
}

-(void)reloadTime:(NSNotification *)sender{
    NSDictionary * dict =(NSDictionary * )sender.object;
    NSInteger tag = [[dict allKeys].firstObject integerValue];
    if (tag == 10000) {
        NSString * beginStr = [dict allValues].firstObject;
        if (![_endText hl_isAvailable]|| ![beginStr compairDate:_endText?:@"" isDate:_isDate]) {
            _beginText = beginStr;
        }else{
            [HLTools showWithText:@"应小于结束时间"];
            return;
        }
    }else{
        NSString * endStr = [dict allValues].firstObject;
        if (![_beginText hl_isAvailable] || [endStr compairDate:_beginText?:@"" isDate:_isDate]) {
            _endText = endStr;
        }else{
            [HLTools showWithText:@"应大于开始时间"];
            return;
        }
    }
    [self.collectionView reloadData];
}

-(void)layoutSubviews{
    [super layoutSubviews];
//    NSLog(@"collectionView = %lf",_collectionView.contentSize.height);
}

-(void)tap:(UITapGestureRecognizer *)sender{
    [self.collectionView endEditing:YES];
}

#pragma mark - UIGestureRecognizerDelegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    UIView * view = touch.view;
    if ([NSStringFromClass([view class]) isEqualToString:@"UICollectionReusableView"]) {
        return YES;
    }
    return NO;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSLog(@"collectionViewsize = %lf",_collectionView.contentSize.height);
    [self.collectionView endEditing:YES];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self endEditing:YES];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:HLReloadShowTimeNotifi object:nil];
    NSLog(@"%s",__func__);
}
@end
