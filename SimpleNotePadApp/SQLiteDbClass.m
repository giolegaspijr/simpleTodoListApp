//
//  SQLiteDbClass.m
//  SimpleNotePadApp
//
//  Created by Sergio Legaspi Jr. on 27/02/2017.
//  Copyright © 2017 Sergio Legaspi Jr. All rights reserved.
//

#import "SQLiteDbClass.h"

#import <sqlite3.h>

#define DB_URL @"/Documents/notesDB.db"

@interface SQLiteDbClass ()

@property (nonatomic) const char *dbFilename;

@end

@implementation SQLiteDbClass
#pragma mark - Initialize DB
-(const char *) dbFilename {
    _dbFilename = [[NSHomeDirectory() stringByAppendingString:DB_URL] UTF8String];
   // NSLog(@"[dbFilename] %s", _dbFilename);
    return _dbFilename;
}

#pragma mark - Read query
- (NSMutableArray *) readQuery: (NSString *) query {
    NSLog(@"[readQuery] start =============== ");
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    
    //init db connection
    sqlite3 *database;
    int result = sqlite3_open(self.dbFilename, &database);
    if (result != SQLITE_OK)
    {
        NSLog(@"[readQuery] error: Can't open database");
        goto close_db;
    }
    NSLog(@"Read query: %@", query);
    
    const char *sql = [query UTF8String];
    sqlite3_stmt *statement;
    result = sqlite3_prepare_v2(database, sql, -1, &statement, NULL);
    
    if (result != SQLITE_OK) {
        NSLog(@"[readQuery] error: Query failed to retrieve data: %s", sqlite3_errmsg(database));
        goto close_db;
    }
    
    while(sqlite3_step(statement) == SQLITE_ROW) {
        int columnCount = sqlite3_column_count(statement);
       // NSLog(@"[readQuery] column count: %d", columnCount);
        NSMutableDictionary *dataRow = [[NSMutableDictionary alloc] init];
        for (int i = 0; i < columnCount; i++) {            
            //get field name
            char *charFieldName = (char *) sqlite3_column_name(statement, i);
            NSString *fieldName = [NSString stringWithUTF8String:charFieldName];
            
            //get field value
            char *charfieldValue = (char *)sqlite3_column_text(statement, i);
            NSString *fieldValue = [NSString stringWithUTF8String:charfieldValue];
            
            NSLog(@"[readQuery] row [%@] => [%@]", fieldName, fieldValue);
            //save to dictionary
            [dataRow setObject:fieldValue forKey:fieldName];
        }
        //add to array
        [resultArray addObject:dataRow];
    }
close_db:
    NSLog(@"[readQuery] Read query start =============== ");
    sqlite3_close(database);
    return resultArray;
}

#pragma mark - Execute query
- (BOOL) executeQuery: (NSString *) query {
    NSLog(@"[executeQuery] Execute query start =============== ");
    sqlite3 *database;
    int result = sqlite3_open(self.dbFilename, &database);
    
    if (result != SQLITE_OK)
    {
        NSLog(@"[executeQuery] error: Can't open database");
        goto close_db;
    }
    //execute sql query
    char *error_message;
    const char *sql = [query UTF8String];
    result = sqlite3_exec(database, sql, NULL, NULL, &error_message);
    
    if (result != SQLITE_OK)
    {
        NSLog(@"[executeQuery] error: Query execution failed due to reason: %s", error_message);
        sqlite3_free(error_message);
        goto close_db;
    }
    NSLog(@"[executeQuery] Execution completed for query: %@", query);
    NSLog(@"[executeQuery] Execute query end =============== ");
    sqlite3_close(database);
    return YES;
close_db:
    sqlite3_close(database);
    NSLog(@"[executeQuery] Execute query end =============== ");
    return NO;
}


@end
