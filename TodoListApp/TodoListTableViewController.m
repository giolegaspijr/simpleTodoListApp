//
//  TodoListTableViewController.m
//
//  Created by Sergio Legaspi Jr. on 27/02/2017.
//  Copyright © 2017 Sergio Legaspi Jr. All rights reserved.
//

#import "TodoListTableViewController.h"
#import "TodoObject.h"
#import "TodoListCell.h"
#import "CustomTextViewController.h"


#define ADD @"add"
#define UPDATE @"update"
#define DELETE @"delete"

@interface TodoListTableViewController () <CustomTextViewControllerDelegate>

@property (nonatomic) TodoObject *myTodos;

@property (nonatomic) NSMutableArray *todoArray;
@property (nonatomic) NSMutableDictionary *todoDictionary;
@property (nonatomic) int todoID;

@end

@implementation TodoListTableViewController {
    UILabel *todoLabel;
    UISwitch *doneSwitch;
}


#pragma mark - Objects
- (TodoObject *)myTodos {
    if (!_myTodos) {
        _myTodos = [[TodoObject alloc] init];
    }
    
    return _myTodos;
}


- (NSMutableArray *) todoArray {
    if (!_todoArray) {
        _todoArray = [[NSMutableArray alloc] init];
    }
    return _todoArray;
}


- (NSMutableDictionary *) todoDictionary {
    if (!_todoDictionary) {
        _todoDictionary = [[NSMutableDictionary alloc] init];
    }
    return _todoDictionary;
}

#pragma mark - app cycle


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.dataTableView setDelegate:self];
    [self.dataTableView setDataSource:self];
    
    
    //
    if ([self.myTodos initTodo]) {
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
        self.todoArray = self.myTodos.todos;
        if (self.todoArray) {
            if ([self.todoArray count] > 0) {
                dispatch_async(dispatch_get_main_queue(), ^  {
                    [self.dataTableView reloadData];
                });
            }
        }
        
        
    });
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (self.todoArray) ? self.todoArray.count : 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Configure the cell...
    if ([self.todoArray count] == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else {
        if (self.todoArray) {
            self.todoDictionary = [[NSMutableDictionary alloc] init];
            if ([self.todoArray count] > indexPath.row) {
                self.todoDictionary = [self.todoArray objectAtIndex:indexPath.row];
                TodoListCell *cell = (TodoListCell *) [tableView dequeueReusableCellWithIdentifier:@"TodoCell"];

                if ([self.todoArray count] > 0) {
                    NSString *todoContent = [NSString stringWithFormat:@"%@", [self.todoDictionary objectForKey:@"todo"]];
                    int todoID = [[NSString stringWithFormat:@"%@",[self.todoDictionary objectForKey:@"todoID"]] intValue];
                    int isDone = [[NSString stringWithFormat:@"%@", [self.todoDictionary objectForKey:@"isDone"]] intValue];
                    
                    [cell.todoLabel setTag:111];
                    todoLabel = (UILabel *)[cell viewWithTag:111];
                    todoLabel.text = todoContent;
                    
                    [cell.doneSwitch setTag:todoID];
                    doneSwitch = (UISwitch *)[cell viewWithTag: todoID];
                    [doneSwitch setOn: isDone > 0 ? YES: NO];
                    
                    [doneSwitch addTarget:self
                                   action:@selector(toggleTodoAction:)
                         forControlEvents:UIControlEventValueChanged];
                    
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

-(IBAction)toggleTodoAction:(id)sender {
    NSInteger index = [sender tag];
    if ([self.myTodos toggleTodo:(int)index]) {
        [self refreshData];
    }
}


#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
   // UINavigationController *navController = segue.destinationViewController;
    NSString *identifier = segue.identifier;
    if ([identifier isEqualToString:@"displayTodoSegue"]) {
        NSIndexPath *selectedRowIndex = [self.dataTableView indexPathForSelectedRow];
        NSInteger index = selectedRowIndex.row;
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        dict = [self.todoArray objectAtIndex:index];
        
        NSString *todoContent = [NSString stringWithFormat:@"%@", [dict objectForKey:@"todo"]];
        int todoID = [[NSString stringWithFormat:@"%@",[dict objectForKey:@"todoID"]] intValue];
        self.todoID = todoID;
       // NSLog (@"[prepareForSegue] index: %ld; ID: %d", (long)index, todoID);
        
        CustomTextViewController *customTextViewController = segue.destinationViewController;
        customTextViewController.delegate = self;
        customTextViewController.textContent = todoContent;
        customTextViewController.action = UPDATE;
        
        NSLog (@"[prepareForSegue] update identifier: %@", identifier);
    }
    else if ([identifier isEqualToString:@"addTodoSegue"]) {
        
        NSLog (@"[prepareForSegue] add todo: %@", identifier);
        CustomTextViewController *customTextViewController = segue.destinationViewController;
        customTextViewController.delegate = self;
        customTextViewController.textContent = @"";
        customTextViewController.action = ADD;
    }

}

#pragma mark - CustomTextFieldDelegate
- (void) getReturnTextWithContent: (NSString *) content forAction:(NSString*) action {
    if ([action isEqualToString:UPDATE]) {
        if ([self.myTodos updateTodo:content withTodoID:self.todoID]) {
            [self refreshData];
        }
    }
    else if ([action isEqualToString:ADD]) {
        if ([self.myTodos saveTodo:content]) {
            [self refreshData];
        }
    }
    else if ([action isEqualToString:DELETE]) {
        if ([self.myTodos deleteTodo:self.todoID]) {
            [self refreshData];
        }
    }
}


@end
