//
//  TodoObject.h
//
//  Created by Sergio Legaspi Jr. on 27/02/2017.
//  Copyright © 2017 Sergio Legaspi Jr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SQLiteDbClass.h"

@interface TodoObject : SQLiteDbClass

- (BOOL) initTodo;

- (BOOL) saveTodo:(NSString *) todo;

- (BOOL) updateTodo:(NSString *) todo withTodoID:(int) todoID;

- (BOOL) deleteTodo:(int) todoID;

- (BOOL) toggleTodo: (int) todoID;

@property (nonatomic) NSMutableArray *todos;

@end
