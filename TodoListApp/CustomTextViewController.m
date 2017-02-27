//
//  TextViewController.m
//
//  Created by Sergio Legaspi Jr. on 27/02/2017.
//  Copyright © 2017 Sergio Legaspi Jr. All rights reserved.
//
#define PLACEHOLDER_TEXT @"Type the things that you want to do..."
#define SIZE_KEYBOARD_HEIGHT 55
#define MAX_CHAR_COUNT_ALLOWED 4000
#define FONT_HELVETICA @"Helvetica Neue"

#import "CustomTextViewController.h"

@interface CustomTextViewController ()


@property (nonatomic) UIView *borderView;
@property (nonatomic) UITextView *noteTextView;
@property (nonatomic) UILabel *counterLabel;
@property (nonatomic) UILabel *noteInstructionLabel;

@end

@implementation CustomTextViewController {
    int char_count;
}

#pragma mark - class/object init
- (UIView *) borderView {
    if (!_borderView) {
        _borderView = [[UIView alloc] init];
        CGRect border_view_frame = CGRectMake(0, 0 + 44, self.view.frame.size.width, self.view.frame.size.height - SIZE_KEYBOARD_HEIGHT);
        _borderView.frame = border_view_frame;
        _borderView.backgroundColor = [UIColor blackColor];
    }
    return _borderView;
}

- (UITextView *) noteTextView {
    if (!_noteTextView) {
        _noteTextView = [[UITextView alloc] init];
        CGRect note_frame = CGRectMake(1, 1, self.view.frame.size.width - 2, (self.view.frame.size.height - SIZE_KEYBOARD_HEIGHT) - 2);
        _noteTextView.frame = note_frame;
        _noteTextView.delegate = self;
        _noteTextView.textColor = [UIColor blackColor];
    }
    return _noteTextView;
}

- (UILabel *) counterLabel {
    if (!_counterLabel) {
        _counterLabel = [[UILabel alloc] init];
        CGRect counter_frame = CGRectMake((self.view.frame.size.width / 2), self.borderView.frame.size.height + 2, (self.view.frame.size.width / 2), 14);
        _counterLabel.frame = counter_frame;
        _counterLabel.textColor = [UIColor grayColor];
        _counterLabel.font = [UIFont fontWithName:FONT_HELVETICA size:12.0f];
        _counterLabel.textAlignment = NSTextAlignmentRight;
        _counterLabel.text = [NSString stringWithFormat:@"%d of %d", char_count, MAX_CHAR_COUNT_ALLOWED];
    }
    return _counterLabel;
}

- (UILabel *) noteInstructionLabel {
    if (!_noteInstructionLabel) {
        _noteInstructionLabel = [[UILabel alloc] init];
        CGRect counter_frame = CGRectMake(5, 8 + 44, (self.view.frame.size.width / 2), 14);
        _noteInstructionLabel.frame = counter_frame;
        _noteInstructionLabel.textColor = [UIColor grayColor];
        _noteInstructionLabel.font = [UIFont fontWithName:FONT_HELVETICA size:12.0f];
        _noteInstructionLabel.textAlignment = NSTextAlignmentLeft;
        _noteInstructionLabel.text = PLACEHOLDER_TEXT;
    }
    return _noteInstructionLabel;
}

#pragma mark - built in functions
- (void)viewDidLoad {
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    char_count = ([self.textContent isEqualToString:@""]) ? 0 : (int)[self.textContent length];
    
    //add objects to main view
    [self.borderView addSubview:self.noteTextView];
    [self.view addSubview:self.borderView];
    [self.view addSubview:self.counterLabel];
    [self.view addSubview:self.noteInstructionLabel];
    
    self.noteTextView.delegate = self;
    self.noteTextView.textColor = [UIColor blackColor];
    self.noteTextView.text = self.textContent;
    
    
    self.noteInstructionLabel.hidden = ([self.noteTextView.text length] > 0);
    
    [super viewDidLoad];
    [self.noteTextView becomeFirstResponder];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.noteTextView resignFirstResponder];
    [super viewWillDisappear:animated];
}

- (BOOL) prefersStatusBarHidden {
    return YES;
}


#pragma mark - UITextView delegate
-(void)textViewDidChange:(UITextView *)textView {
    char_count = (int) textView.text.length;
    self.counterLabel.text = [NSString stringWithFormat:@"%d of %d", char_count, MAX_CHAR_COUNT_ALLOWED];
    self.noteInstructionLabel.hidden = (char_count > 0);
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    char_count = (int) textView.text.length + (int)text.length;
    if (([text isEqualToString:@""])) {
        return YES;
    }
    else {
        if (char_count <= MAX_CHAR_COUNT_ALLOWED) {
            return YES;
        }
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Oops!"
                                                                   message:@"You've reached the max allowable character"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok"
                                                       style:UIAlertActionStyleCancel
                                                     handler:nil];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
    return NO;
}

#pragma mark - UIButton actions
- (IBAction)backAction:(id)sender {
    [self.noteTextView resignFirstResponder];
    
    if ([self.noteTextView.text isEqualToString:@""] || [self.noteTextView.text isEqualToString:PLACEHOLDER_TEXT]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Are you sure?"
                                                                       message:@"Changes will NOT be saved"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"No"
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];
        UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"Yes"
                                                           style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction *action) {
                                                              [self dismissViewControllerAnimated:YES completion:nil];
                                                         }];
        [alert addAction:noAction];
        [alert addAction:yesAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}


- (IBAction) doneAction: (id) sender {
    NSString *textAreaContent = @"";
    textAreaContent = [self.noteTextView text];
    NSString *trimmedTextAreaContent = @"";
    trimmedTextAreaContent = [textAreaContent stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([trimmedTextAreaContent isEqualToString:PLACEHOLDER_TEXT]) {
        trimmedTextAreaContent = @"";
    }
    [self.delegate getReturnTextWithContent:trimmedTextAreaContent forAction:self.action];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)deleteAction:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Are you sure?"
                                                                   message:@"This can't be undone"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"No"
                                                       style:UIAlertActionStyleCancel
                                                     handler:nil];
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"Yes"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action) {
                                                          self.action = @"delete";
                                                          [self.delegate getReturnTextWithContent:@"" forAction:self.action];
                                                          
                                                          [self dismissViewControllerAnimated:YES completion:nil];
                                                      }];
    [alert addAction:noAction];
    [alert addAction:yesAction];
    [self presentViewController:alert animated:YES completion:nil];

}

@end





