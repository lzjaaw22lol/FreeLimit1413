//
//  ZJCreateDb.h
//  FreeLimit1413
//
//  Created by qf on 15-3-17.
//  Copyright (c) 2015年 qf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
@interface ZJCreateDb : NSObject{
    FMDatabase *fmdb;
}
+(ZJCreateDb *)defaultManager;
-(ZJCreateDb *)initDb;
-(BOOL)addMsg:(NSDictionary *)dict;
-(BOOL)removeMsg:(NSString *)str;
-(NSMutableArray *)selectAllMsg;
-(BOOL)isShouCang:(NSString *)appid;
@end
