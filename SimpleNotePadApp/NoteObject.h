//
//  NoteObject.h
//  SimpleNotePadApp
//
//  Created by Sergio Legaspi Jr. on 27/02/2017.
//  Copyright © 2017 Sergio Legaspi Jr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SQLiteDbClass.h"

@interface NoteObject : SQLiteDbClass

- (BOOL) initNote;

- (BOOL) saveNote:(NSString *) note;

- (BOOL) updateNote:(NSString *) note withNoteID:(int) noteID;

- (BOOL) deleteNote:(int) noteID;

@property (nonatomic) NSMutableArray *notes;

@end
