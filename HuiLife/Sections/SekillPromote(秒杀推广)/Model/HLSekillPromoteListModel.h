//
//  HLSekillPromoteListModel.h
//  HuiLife
//
//  Created by 王策 on 2019/8/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HLSekillPromoteListModel : NSObject

@property (nonatomic, copy) NSString *Id;

@property (nonatomic, copy) NSString *pic;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) double orgPrice;
@property (nonatomic, assign) double price;
@property (nonatomic, assign) double floorPrice;

@property (nonatomic, copy) NSString *popularize; // 一般
@property (nonatomic, copy) NSString *popularColor;


///
@property (nonatomic, strong) NSAttributedString *priceAttr;

@end

NS_ASSUME_NONNULL_END
