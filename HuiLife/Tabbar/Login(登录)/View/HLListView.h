//
//  HLListView.h
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/7/17.
//

#import <UIKit/UIKit.h>

@class HLListView;
@protocol ZCDropDownDelegate
- (void)dropDownDelegateMethod: (HLListView *) sender;

-(void)didSelectItem:(NSString *)text;
@end

@interface HLListView : UIView<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, retain) UITableView *tableV;

-(void)hideDropDown:(CGRect)b;

-(id)initWithShowDropDown:(CGRect)button height:(CGFloat)height arr:(NSArray *)arr;
@property (nonatomic, retain) id <ZCDropDownDelegate> delegate;
@end
