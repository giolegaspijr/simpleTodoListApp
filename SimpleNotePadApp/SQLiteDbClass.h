//
//  SQLiteDbClass.h
//  SimpleNotePadApp
//
//  Created by Sergio Legaspi Jr. on 27/02/2017.
//  Copyright © 2017 Sergio Legaspi Jr. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SQLiteDbClass : NSObject

- (NSMutableArray *) readQuery: (NSString *) query;

- (BOOL) executeQuery: (NSString *) query;

@end
