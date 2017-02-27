//
//  CustomTextViewController.h
//  SimpleNotePadApp
//
//  Created by Sergio Legaspi Jr. on 27/02/2017.
//  Copyright © 2017 Sergio Legaspi Jr. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomTextViewControllerDelegate <NSObject>

@required
- (void) getReturnTextWithContent: (NSString *) content forAction:(NSString*) action;

@end


@interface CustomTextViewController : UIViewController <UITextViewDelegate>

@property (nonatomic, strong) id <CustomTextViewControllerDelegate> delegate;


@property (nonatomic) NSString *textContent;
@property (nonatomic) NSString *action;

- (IBAction)backAction:(id)sender;
- (IBAction)doneAction:(id)sender;
- (IBAction)deleteAction:(id)sender;

@end
