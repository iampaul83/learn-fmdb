//
//  ViewController.m
//  learn-fmdb
//
//  Created by Paul on 4/8/15.
//  Copyright (c) 2015 Paul. All rights reserved.
//

#import "ViewController.h"
#import "FMDatabase.h"

@interface ViewController ()
@property (strong, nonatomic) FMDatabase *db;
/// db路徑位於Document下，檔名為`db.db`
@property (readonly, nonatomic) NSString *dbPath;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 把之前的db砍掉重練，因為我們在練功嘛～
    NSFileManager *fm = [NSFileManager defaultManager];
    [fm removeItemAtPath:self.dbPath error:nil];
    
    // 初始化FMDatabase物件，若db檔案不存在則會自動建立新檔
    self.db = [FMDatabase databaseWithPath:self.dbPath];
    
    // 開始使用db前必須先開啟
    BOOL dbOpenSuccess = [self.db open];
    if ( !dbOpenSuccess ) {
        self.db = nil;
        NSLog(@"無法開啟db");
        return;
    }

    // create table
    [self.db executeUpdate:@"create table sm_phone (    \
        company    text     not null,                   \
        name       text     not null unique,            \
        os         text     not null,                   \
        price      double   not null                    \
     )"];
    
    // 弄一些假資料
    NSArray *phones = @[
                       @[@"Apple", @"iPhone", @"iOS", @12345],
                       @[@"Google", @"Nexus 6", @"Android", @99],
                       @[@"HTC", @"One", @"Android", @123.321],
                       @[@"Nokia", @"???", @"Windows", @3333]
                    ];
    
    // 把假資料放到sqlite
    for (NSArray *phone in phones) {
        [self.db executeUpdate:@"insert into sm_phone (company, name, os, price) values (?, ?, ?, ?)"
                 withArgumentsInArray:phone];
    }
    
    // 搜尋
    FMResultSet *queryResult = [self.db executeQuery:@"select * from sm_phone order by price asc"];
    
    // fetch result
    while ( [queryResult next] ) {
        //一些可以取得資料的方法
        NSString *company = [queryResult stringForColumn:@"company"];
        NSString *name = [queryResult objectForColumnName:@"name"];
        //個人偏好下面這種
        NSString *os = queryResult[@"os"];
        NSNumber *price = queryResult[@"price"];
        NSLog(@"%@ %@(%@) $%@", company, name, os, price);
    }
    
    [self.db close];
    
}

#pragma mark - getters
-(NSString *)dbPath {
    NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *dbPath = [docPath stringByAppendingPathComponent:@"db.db"];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
       NSLog(@"db path: %@",dbPath);
    });
    return dbPath;
}

@end
