//
//  HLPeripheral.h
//  HuiLife
//
//  Created by 闻喜惠生活 on 2018/12/10.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

typedef void(^CallBack)(void);

@interface HLPeripheral : NSObject

+ (void)conncetPeripheral:(CBPeripheral *)peripheral callBack:(CallBack)callBack;

@end

