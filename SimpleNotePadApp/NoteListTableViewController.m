//
//  NoteListTableViewController.m
//  SimpleNotePadApp
//
//  Created by Sergio Legaspi Jr. on 27/02/2017.
//  Copyright © 2017 Sergio Legaspi Jr. All rights reserved.
//

#import "NoteListTableViewController.h"
#import "NoteObject.h"
#import "NoteListCellTableViewCell.h"
#import "CustomTextViewController.h"


#define ADD @"add"
#define UPDATE @"update"
#define DELETE @"delete"

@interface NoteListTableViewController () <CustomTextViewControllerDelegate>

@property (nonatomic) NoteObject *myNotes;

@property (nonatomic) NSMutableArray *noteArray;
@property (nonatomic) NSMutableDictionary *noteDictionary;
@property (nonatomic) int noteID;

@end

@implementation NoteListTableViewController {
    UILabel *noteLabel;
}


#pragma mark - Objects
- (NoteObject *) myNotes {
    if (!_myNotes) {
        _myNotes = [[NoteObject alloc] init];
    }
    
    return _myNotes;
}


- (NSMutableArray *) noteArray {
    if (!_noteArray) {
        _noteArray = [[NSMutableArray alloc] init];
    }
    return _noteArray;
}


- (NSMutableDictionary *) noteDictionary {
    if (!_noteDictionary) {
        _noteDictionary = [[NSMutableDictionary alloc] init];
    }
    return _noteDictionary;
}

#pragma mark - app cycle


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.dataTableView setDelegate:self];
    [self.dataTableView setDataSource:self];
    
    
    //
    if ([self.myNotes initNote]) {
        [self refreshData];
    }
    else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Oops"
                                                                       message:@"No data found"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            //do nothing....
        }];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)prefersStatusBarHidden {
    return YES;
}
#pragma mark - Table refresher
- (void) refreshData {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.noteArray = self.myNotes.notes;
        if (self.noteArray) {
            if ([self.noteArray count] > 0) {
                dispatch_async(dispatch_get_main_queue(), ^  {
                    [self.dataTableView reloadData];
                });
            }
        }
        
        
    });
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (self.noteArray) ? self.noteArray.count : 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Configure the cell...
    if ([self.noteArray count] == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else {
        if (self.noteArray) {
            self.noteDictionary = [[NSMutableDictionary alloc] init];
            if ([self.noteArray count] > indexPath.row) {
                self.noteDictionary = [self.noteArray objectAtIndex:indexPath.row];
                NoteListCellTableViewCell *cell = (NoteListCellTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"NoteCell"];

                if ([self.noteArray count] > 0) {
                    NSString *noteContent = [NSString stringWithFormat:@"%@", [self.noteDictionary objectForKey:@"note"]];
                    
                    [cell.noteSnippetLabel setTag:111];
                    noteLabel = (UILabel *)[cell viewWithTag:111];
                    
                    noteLabel.text = noteContent;
                    
                }
                return cell;
            }
        }
    }
    
    //ELSE.....
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
    return cell;
}


#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
   // UINavigationController *navController = segue.destinationViewController;
    NSString *identifier = segue.identifier;
    if ([identifier isEqualToString:@"displayNoteSegue"]) {
        NSIndexPath *selectedRowIndex = [self.dataTableView indexPathForSelectedRow];
        NSInteger index = selectedRowIndex.row;
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        dict = [self.noteArray objectAtIndex:index];
        
        NSString *noteContent = [NSString stringWithFormat:@"%@", [dict objectForKey:@"note"]];
        int noteID = [[NSString stringWithFormat:@"%@",[dict objectForKey:@"noteID"]] intValue];
        self.noteID = noteID;
       // NSLog (@"[prepareForSegue] index: %ld; ID: %d", (long)index, noteID);
        
        CustomTextViewController *customTextViewController = segue.destinationViewController;
        customTextViewController.delegate = self;
        customTextViewController.textContent = noteContent;
        customTextViewController.action = UPDATE;
        
        NSLog (@"[prepareForSegue] update identifier: %@", identifier);
    }
    else if ([identifier isEqualToString:@"addNoteSegue"]) {
        
        NSLog (@"[prepareForSegue] add note: %@", identifier);
        CustomTextViewController *customTextViewController = segue.destinationViewController;
        customTextViewController.delegate = self;
        customTextViewController.textContent = @"";
        customTextViewController.action = ADD;
    }

}

#pragma mark - CustomTextFieldDelegate
- (void) getReturnTextWithContent: (NSString *) content forAction:(NSString*) action {
    if ([action isEqualToString:UPDATE]) {
        if ([self.myNotes updateNote:content withNoteID:self.noteID]) {
            [self refreshData];
        }
    }
    else if ([action isEqualToString:ADD]) {
        if ([self.myNotes saveNote:content]) {
            [self refreshData];
        }
    }
    else if ([action isEqualToString:DELETE]) {
        if ([self.myNotes deleteNote:self.noteID]) {
            [self refreshData];
        }
    }
}


@end
