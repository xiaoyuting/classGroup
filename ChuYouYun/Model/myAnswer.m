//
//  myAnswer.m
//  ChuYouYun
//
//  Created by 智艺创想 on 16/4/11.
//  Copyright (c) 2016年 ZhiYiForMac. All rights reserved.
//

#import "myAnswer.h"
#import "FMDB.h"

@implementation myAnswer

static FMDatabase *_db;
+ (void)initialize {
    //打开数据库
//    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"myAnswer.sqlite"];
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Private Documents/Temp/myAnswer.sqlite"];
    _db = [FMDatabase databaseWithPath:path];
    [_db open];
    
    //创表
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_myAnswer (myAnswer NOT NULL);"];
    
}

+ (NSArray *)BJWithDic:(NSMutableDictionary *)dic {
    
    //根据请求参数生成对应的SQL语句
    NSString *sql = @"SELECT * FROM t_myAnswer";
    
    //执行SQL
    FMResultSet *set = [_db executeQuery:sql];
    NSMutableArray *classes = [NSMutableArray array];
    while (set.next) {
        NSData *blumData = [set objectForColumnName:@"myAnswer"];
        NSDictionary *blum = [NSKeyedUnarchiver unarchiveObjectWithData:blumData];
        [classes addObject:blum];
    }
    return classes;
}


+ (void)saveBJes:(NSArray *)SYGBJ {
    
    //要将一个对象存进数据库的blob字段，最好先转为NSData
    for (NSDictionary *class in SYGBJ ) {
        NSData *classData = [NSKeyedArchiver archivedDataWithRootObject:class];
        [_db executeUpdateWithFormat:@"INSERT INTO t_myAnswer(myAnswer) VALUES (%@);",classData];
    }
    
}


@end
