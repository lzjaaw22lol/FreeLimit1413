//
//  ZJCreateDb.m
//  FreeLimit1413
//
//  Created by qf on 15-3-17.
//  Copyright (c) 2015年 qf. All rights reserved.
//

#import "ZJCreateDb.h"

@implementation ZJCreateDb
static ZJCreateDb *zdb;
+(ZJCreateDb *)defaultManager{
    if(!zdb){
        zdb = [[ZJCreateDb alloc] initDb];
    }
    return zdb;
}
-(ZJCreateDb *)initDb{
    if(self = [super init]){
        fmdb = [[FMDatabase alloc] initWithPath:[self getPath]];
    }
    if(![fmdb open])
        return nil;
    NSString *sql = @"create table if not exists xianmian  ("
    " id integer primary key autoincrement not null, "
    " recordType varchar(32), "
    " applicationId varchar(64) not null, "
    " name varchar(128), "
    " iconUrl varchar(128), "
    " type varchar(32) ,"
    " lastPrice varchar(32), "
    " currentPrice varchar(32) "
    ")";
    BOOL isopen = [fmdb executeUpdate:sql];
    if(isopen)
        NSLog(@"表创建成功");
    else
        NSLog(@"表创建失败");
    return self;
}
-(NSString *)getPath{
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *filepath = [path stringByAppendingPathComponent:@"xm.db"];
    return filepath;
}
-(BOOL)addMsg:(NSDictionary *)dict{
    NSString *sql = @"insert into xianmian (recordType,applicationId,name,iconUrl,type,lastPrice,currentPrice) values (%@,%@,%@,%@,%@,%@,%@)";
    BOOL isInsert = [fmdb executeUpdateWithFormat:sql,dict[@"recordType"],dict[@"applicationId"],dict[@"name"],dict[@"iconUrl"],dict[@"type"],dict[@"lastPrice"],dict[@"currentPrice"]];
    if(isInsert)
        NSLog(@"插入成功");
    else
        NSLog(@"插入失败");
    return isInsert;
}
-(BOOL)removeMsg:(NSString *)str{
    NSString *sql = @"delete from xianmian where applicationId=%@";
    BOOL isRemove = [fmdb executeUpdateWithFormat:sql,str];
    if(isRemove)
        NSLog(@"删除成功");
    else
        NSLog(@"删除失败");
    return isRemove;
}
-(NSMutableArray *)selectAllMsg{
    NSArray *xt = [NSArray arrayWithObjects:@"recordType",@"applicationId",@"name",@"iconUrl",@"type",@"lastPrice",@"currentPrice",nil];
    NSMutableArray *res = [[NSMutableArray alloc] init];
    NSString *sql = [NSString stringWithFormat:@"select * from xianmian"];
    FMResultSet *set = [fmdb executeQuery:sql];
    while (set.next) {
        NSMutableDictionary *dictSelect = [[NSMutableDictionary alloc] init];
        for(int i=0;i<xt.count;i++){
            [dictSelect setObject:[set stringForColumn:xt[i]] forKey:xt[i]];
        }
        [res addObject:dictSelect];
    }
    return res;
}
-(BOOL)isShouCang:(NSString *)appid{
    NSString *sql = @"select * from xianmian where applicationId=%@";
    FMResultSet *set = [fmdb executeQueryWithFormat:sql,appid];
    if(set.next)
        return YES;
    else
        return NO;

}
-(void)createTable{
    
}
@end
