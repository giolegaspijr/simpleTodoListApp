//
//  NoteObject.m
//  SimpleNotePadApp
//
//  Created by Sergio Legaspi Jr. on 27/02/2017.
//  Copyright © 2017 Sergio Legaspi Jr. All rights reserved.
//

#import "NoteObject.h"


@implementation NoteObject


/**
 @brief: init Note
 */
- (BOOL) initNote {
    //Create draft table
    NSString *draftTableQuery = @"CREATE TABLE IF NOT EXISTS notes (noteID INTEGER PRIMARY KEY AUTOINCREMENT, note TEXT)";
    if ([self executeQuery:draftTableQuery]) {
        NSLog(@"[initNote] Note table created successfully");
    }
    return YES;
}


/**
 @brief: get Note
 */
- (NSMutableArray *) notes {
    _notes = [[NSMutableArray alloc] init];
    
    NSString *query = [NSString stringWithFormat:@"SELECT noteID, note FROM notes"];
    _notes = [self readQuery:query];
    
    return _notes;
}

/**
 @brief: save note
 */
- (BOOL) saveNote:(NSString *)note {
    if ([note isEqualToString:@""]) {
        NSLog(@"[saveNote] ERROR: empty note");
        return NO;
    }
    
    NSString *query = [NSString stringWithFormat:@"INSERT INTO notes (note) VALUES ('%@')", note];
    return [self executeQuery:query];
}

/**
 @brief: update note
 */
- (BOOL) updateNote:(NSString *)note withNoteID:(int)noteID {
    if ([note isEqualToString:@""]) {
        NSLog(@"[updateNote] ERROR: empty note");
        return NO;
    }
    
    NSString *query = [NSString stringWithFormat: @"UPDATE notes SET note = '%@' WHERE noteID=%d", note, noteID];
    
    return [self executeQuery:query];
}

/**
 @brief: delete note
 */
- (BOOL) deleteNote:(int)noteID {
    NSString *query = [NSString stringWithFormat:@"DELETE FROM notes WHERE noteID = %d", noteID];
    return  [self executeQuery:query];
}

@end
