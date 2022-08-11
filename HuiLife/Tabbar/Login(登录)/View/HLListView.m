//
//  HLListView.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/7/17.
//

#import "HLListView.h"
#import "HLListViewCell.h"

@interface HLListView ()

@property(nonatomic, assign) CGRect btnSender;
@property(nonatomic, retain) NSMutableArray *list;
@property(nonatomic, retain) NSMutableArray *delArr;
@property(copy,nonatomic)NSString * currentText;
@property(assign,nonatomic)CGFloat hight;
@end
@implementation HLListView

-(id)initWithShowDropDown:(CGRect)button height:(CGFloat)height arr:(NSArray *)arr{
    _btnSender = button;
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        CGRect btn = button;
        if (arr.count > 3) {
            _hight = 40*3;
        }else{
            _hight = 40* arr.count;
        }
        self.frame = CGRectMake(btn.origin.x, btn.origin.y+btn.size.height, btn.size.width, 0);
        self.list = [NSMutableArray arrayWithArray:arr];
        self.delArr = [NSMutableArray arrayWithArray:self.list];
        self.layer.masksToBounds = NO;
        self.layer.cornerRadius = 8;
        _tableV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, btn.size.width, 0)];
        _tableV.delegate = self;
        _tableV.dataSource = self;
        _tableV.layer.cornerRadius = 5;
        _tableV.backgroundColor = [UIColor colorWithRed:0.619 green:0.239 blue:0.239 alpha:1];
        _tableV.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableV.backgroundColor = [UIColor whiteColor];
        _tableV.rowHeight = 40;
//        [_tableV.layer setBorderWidth:1];
//        [_tableV.layer setBorderColor:UIColorFromRGB(0xFF8D26).CGColor];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.2];
        self.frame = CGRectMake(btn.origin.x, btn.origin.y+btn.size.height, btn.size.width, _hight);
        _tableV.frame = CGRectMake(0, 0, btn.size.width, _hight);
        [UIView commitAnimations];
//        [button.superview addSubview:self];
        //解决tableView线不能铺满的问题
        if ([self.tableV respondsToSelector:@selector(setSeparatorInset:)]){
            [self.tableV setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([self.tableV respondsToSelector:@selector(setLayoutMargins:)]) {
            [self.tableV setLayoutMargins:UIEdgeInsetsZero];
        }
        [self addSubview:_tableV];
    }
    return self;
}

-(void)hideDropDown:(CGRect)b {
    CGRect btn = b;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    self.frame = CGRectMake(btn.origin.x, btn.origin.y+btn.size.height, btn.size.width, 0);
    _tableV.frame = CGRectMake(0, 0, btn.size.width, 0);
    [UIView commitAnimations];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* indentifier = @"cell";
    HLListViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[HLListViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:indentifier];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.textColor = UIColorFromRGB(0xFF565656);
    cell.textLabel.text = self.list[indexPath.row];
    cell.backgroundColor = UIColorFromRGB(0xFFF9F9F9);
//    cell.imageV.tag = indexPath.row;
//    cell.imageV.userInteractionEnabled = YES;
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
//    [cell.imageV addGestureRecognizer:tap];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self hideDropDown:_btnSender];
        UITableViewCell *c = [tableView cellForRowAtIndexPath:indexPath];
    [self.delegate didSelectItem:c.textLabel.text];
    _currentText = c.textLabel.text;
    [self myDelegate];
}

- (void) myDelegate {
    [self.delegate dropDownDelegateMethod:self];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
@end
