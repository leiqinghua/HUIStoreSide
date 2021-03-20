//
//  UITableViewCell+HLConfiger.m
//  HuiLife
//
//  Created by 闻喜惠生活 on 2019/3/13.
//

#import "UITableViewCell+HLConfiger.h"

@implementation UITableViewCell (HLConfiger)

+(instancetype)dequeueReusableCell:(UITableView *)tableView{
    
    NSString * Id = [NSString stringWithFormat:@"%@ID",NSStringFromClass(self)];
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:Id];
    
    if (!cell) {
        cell = [[self alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Id];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
@end
