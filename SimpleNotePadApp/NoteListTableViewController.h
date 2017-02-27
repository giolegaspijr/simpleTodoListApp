//
//  NoteListTableViewController.h
//  SimpleNotePadApp
//
//  Created by Sergio Legaspi Jr. on 27/02/2017.
//  Copyright © 2017 Sergio Legaspi Jr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoteListTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *dataTableView;

@end
