//
//  UITableView+HLExtension.m
//  HuiLife
//
//  Created by 雷清华 on 2019/12/13.
//

#import "UITableView+HLExtension.h"

@implementation UITableView (HLExtension)

- (UITableViewCell *)hl_dequeueReusableCellWithIdentifier:(NSString *)identifier indexPath:(NSIndexPath *)indexPath{
    Class cls = NSClassFromString(identifier);
    if (cls) {
        UITableViewCell *cell = [self dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[cls alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        return cell;
    }
    return nil;
}

@end
