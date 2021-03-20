//
//  HLAccount.m
//  HuiLife
//
//  Created by 雷清华 on 2020/7/24.
//

#import "HLAccount.h"
#import <JPUSHService.h>

@implementation HLAccount 

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"userid":@"id"};
}

static HLAccount *_instance;
+ (instancetype)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [self decodeAcount];
        if (!_instance) {
            _instance = [[HLAccount alloc]init];
        }
    });
    return _instance;
}

- (void)clearAll {
    self.userid = @"";
    self.token = @"";
    self.is_yy = NO;
    self.mobile = @"";
    self.name = @"";
    self.store_address = @"";
    self.store_name = @"";
    self.store_id = @"";
    self.user_name = @"";
    self.push_store_id = @[];
    self.userIdBuss = @"";
    self.lmpt_userid = @"";
     
}

- (BOOL)admin {
    return _role == 1;
}

- (BOOL)isDZ {
    return _role == 2;
}

- (BOOL)isLogin {
    return _token.length;
}

- (NSInteger)print_count {
    if (_print_count == 0) {
        return 1;
    }
    return _print_count;
}

- (NSInteger)order_mode {
    if (_order_mode == 0) {
        return 1;
    }
    return _order_mode;
}

- (NSInteger)print_mode {
    if (_print_mode == 0) {
        return 3;
    }
    return _print_mode;
}

- (void)exitLogin {
    [self clearAll];
    [HLAccount saveAcount];
//    删除导出文件
    NSString *dirPath = [HLFileManager cusExportDir];
    [HLFileManager deleteFile:dirPath];
    
    
// 清除标签
    [JPUSHService cleanTags:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
        NSLog(@"clean = %ld",iResCode);
    } seq:10000];
}

- (void)saveYYStatu {
    NSUserDefaults *userDefault = [[NSUserDefaults alloc]initWithSuiteName:@"group.HuiLift"];
    [userDefault setObject:@(_is_yy) forKey:@"is_yy"];
    [userDefault synchronize];
}


+ (void)saveAcount {
    [self saveToPath:@"Account" model:[HLAccount shared]];
}

+ (HLAccount *)decodeAcount {
    return (HLAccount *)[self decodeFromPath:@"Account"];
}

//归档对象
+ (void)saveToPath:(NSString *)path model:(NSObject<NSCoding> *)model{
    NSString *docPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath  = [docPath stringByAppendingPathComponent:path];
    BOOL success = [NSKeyedArchiver archiveRootObject:model toFile:filePath];
    if (!success) {
        HLLog(@"存储失败 = %@",filePath);
    }
}

//接档
+ (NSObject<NSCoding>*)decodeFromPath:(NSString *)path{
    //1.获取文件路径
    NSString *docPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    //2、添加储存的文件名
    NSString *filePath  = [docPath stringByAppendingPathComponent:path];
    //3、将对象从文件中取出
    NSObject<NSCoding> * model = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    return model;
}

#pragma mark - NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.userid forKey:@"userid"];
    [aCoder encodeInteger:self.role forKey:@"role"];
    [aCoder encodeObject:self.token forKey:@"token"];
    [aCoder encodeBool:self.is_yy forKey:@"is_yy"];
    [aCoder encodeObject:self.mobile forKey:@"mobile"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.store_address forKey:@"store_address"];
    [aCoder encodeObject:self.store_name forKey:@"store_oriange"];
    [aCoder encodeObject:self.user_name forKey:@"user_name"];
    [aCoder encodeObject:self.store_id forKey:@"store_id"];
    [aCoder encodeObject:self.push_store_id forKey:@"push_store_id"];
    [aCoder encodeBool:self.store_send forKey:@"store_send"];
    [aCoder encodeObject:self.userIdBuss forKey:@"userIdBuss"];
    [aCoder encodeBool:self.printSet forKey:@"printSet"];
    [aCoder encodeObject:self.lmpt_userid forKey:@"lmpt_userid"];
    [aCoder encodeObject:self.latitude forKey:@"latitude"];
    [aCoder encodeObject:self.longitude forKey:@"longitude"];
    [aCoder encodeObject:self.locateJSON forKey:@"locateJSON"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self=[super init];
    if(self)
    {
        self.userid=[aDecoder decodeObjectForKey:@"userid"];
        self.role = [aDecoder decodeIntegerForKey:@"role"];
        self.token=[aDecoder decodeObjectForKey:@"token"];
        self.is_yy = [aDecoder decodeBoolForKey:@"is_yy"];
        self.mobile = [aDecoder decodeObjectForKey:@"mobile"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.store_address = [aDecoder decodeObjectForKey:@"store_address"];
        self.store_name = [aDecoder decodeObjectForKey:@"store_oriange"];
        self.user_name = [aDecoder decodeObjectForKey:@"user_name"];
        self.store_id = [aDecoder decodeObjectForKey:@"store_id"];
        self.push_store_id = [aDecoder decodeObjectForKey:@"push_store_id"];
        self.store_send = [aDecoder decodeBoolForKey:@"store_send"];
        self.userIdBuss = [aDecoder decodeObjectForKey:@"userIdBuss"];
        self.printSet = [aDecoder decodeBoolForKey:@"printSet"];
        self.lmpt_userid = [aDecoder decodeObjectForKey:@"lmpt_userid"];
        self.latitude = [aDecoder decodeObjectForKey:@"latitude"];
        self.longitude = [aDecoder decodeObjectForKey:@"longitude"];
        self.locateJSON = [aDecoder decodeObjectForKey:@"locateJSON"];
    }
    return self;
}
@end
