//
//  TodoObject.m
//
//  Created by Sergio Legaspi Jr. on 27/02/2017.
//  Copyright © 2017 Sergio Legaspi Jr. All rights reserved.
//

#import "TodoObject.h"


@implementation TodoObject


/**
 @brief: init Todo
 */
- (BOOL) initTodo {
    //Create draft table
    NSString *draftTableQuery = @"CREATE TABLE IF NOT EXISTS todos (todoID INTEGER PRIMARY KEY AUTOINCREMENT, todo TEXT, isDone INTEGER DEFAULT 0)";
    if ([self executeQuery:draftTableQuery]) {
        NSLog(@"[initTodo] Todo table created successfully");
    }
    return YES;
}


/**
 @brief: get Todo
 */
- (NSMutableArray *) todos {
    _todos = [[NSMutableArray alloc] init];
    
    NSString *query = [NSString stringWithFormat:@"SELECT todoID, todo, isDone FROM todos"];
    _todos = [self readQuery:query];
    
    return _todos;
}

/**
 @brief: save Todo
 */
- (BOOL) saveTodo:(NSString *)todo {
    if ([todo isEqualToString:@""]) {
        NSLog(@"[saveTodo] ERROR: empty todo");
        return NO;
    }
    
    NSString *query = [NSString stringWithFormat:@"INSERT INTO todos (todo) VALUES ('%@')", todo];
    return [self executeQuery:query];
}

/**
 @brief: update Todo
 */
- (BOOL) updateTodo:(NSString *)todo withTodoID:(int)todoID {
    if ([todo isEqualToString:@""]) {
        NSLog(@"[updateTodo] ERROR: empty todo");
        return NO;
    }
    
    NSString *query = [NSString stringWithFormat: @"UPDATE todos SET todo = '%@' WHERE todoID=%d", todo, todoID];
    
    return [self executeQuery:query];
}

/**
 @brief: delete Todo
 */
- (BOOL) deleteTodo: (int)todoID {
    NSString *query = [NSString stringWithFormat:@"DELETE FROM todos WHERE todoID = %d", todoID];
    return  [self executeQuery:query];
}


/**
 @brief: update Todo item's status
 */
- (BOOL) toggleTodo:(int)todoID {
    NSString *query = [NSString stringWithFormat: @"UPDATE todos SET isDone = (CASE WHEN isDone = 1 THEN 0 ELSE 1 END) WHERE todoID=%d", todoID];
    
    return [self executeQuery:query];
}

@end
