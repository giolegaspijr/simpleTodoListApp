//
//  TodoListCell.h
//
//  Created by Sergio Legaspi Jr. on 27/02/2017.
//  Copyright © 2017 Sergio Legaspi Jr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TodoListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UISwitch *doneSwitch;
@property (weak, nonatomic) IBOutlet UILabel *todoLabel;

@end
