# learn-fmdb
- PART 1 - Hello fmdb
- PART 2 - Coming soon...

## 安裝
1. <a href="https://github.com/ccgus/fmdb" target="_blank">下載FMDB</a>
2. 將`fmdb/src/fmdb`資料夾拖進專案
3. 連結sqlite3.dylib <a href="https://raw.githubusercontent.com/iampaul83/learn-fmdb/master/imgs-for-md/img1.png" target="_blank">圖解</a>
4. `#import "FMDatabase.h"`

## Hello fmdb
##### ViewController.m
###### 初始化FMDatabase物件
```Objective-C
// 若該路徑檔案不存在將會自動建立新檔
FMDatabase *db = [FMDatabase databaseWithPath:self.dbPath];
```
###### 開啟檔案
```Objective-C
// 開始使用db前必須先開啟
BOOL dbOpenSuccess = [db open];
if ( !dbOpenSuccess ) {
  NSLog(@"無法開啟db");
  return;
}
```
###### Create Table
```Objective-C
[db executeUpdate:@"create table hello (col1 text, col2 integer)"];
```
###### Insert into
```Objective-C
// 數字型態的欄位以NSNumber物件傳入
[db executeUpdate:@"insert into hello (col1, col2) values (?, ?)", @"hihi", @123];
```
###### Query
```Objective-C
FMResultSet *queryResult = [db executeQuery:@"select * from hello"];
```
###### Fetch result
* 一些可以取得資料的方法
* 請愛用Subscript(`queryResult[@"col1"]`) ->
  * <a href="http://ccgus.github.io/fmdb/html/Classes/FMResultSet.html#//api/name/objectAtIndexedSubscript:" target="_blank">FMResultSet.objectAtIndexedSubscript:</a>
  * <a href="http://ccgus.github.io/fmdb/html/Classes/FMResultSet.html#//api/name/objectForKeyedSubscript:" target="_blank">FMResultSet.objectForKeyedSubscript:</a>

```Objective-C
while ( [queryResult next] ) {
  NSString *col1 = [queryResult stringForColumn:@"col1"];
            col1 = [queryResult objectForColumnName:@"col1"];
            col1 = queryResult[@"col1"];
  
  int col2_int = [queryResult intForColumn:@"col2"];
  NSNumber *col2_NSNumber = [queryResult objectForColumnName:@"col2"];
            col2_NSNumber = queryResult[@"col2"];
}
```
###### 關於上面的` while `與` [queryResult next] `
1. ` [queryResult next] -> YES `：還有資料 -> **3**
2. ` [queryResult next] -> NO `：沒資料了 -> **結束while**
3. 在queryResult目前指向的row收資料
4. **↻ 1**

###### Close db
```Objective-C
[db close];
```

## 練習
1. 建立db
2. 建立table
3. 用TableView實作新增、修改、刪除
