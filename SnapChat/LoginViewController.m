//
//  LoginViewController.m
//  SnapChat
//
//  Created by Sherrie Jones on 2/19/15.
//  Copyright (c) 2015 Sherrie Jones. All rights reserved.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // remove back button to Inbox on login screen
    self.navigationItem.hidesBackButton = YES;


}

- (IBAction)loginButton:(UIButton *)sender {
    // Capture data entered in textFields and remove all spaces & new line chars
    NSString *username = [self.usernameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = [self.passwordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    // show error message if any field is empty
    if ([username length] == 0 || [password length] == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops!" message:@"Make sure you enter a username and password!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    } else {
        // call class name not an object on login method
        [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser *user, NSError *error) {
            // show error message if any error with data
            if (error) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry!" message:[error.userInfo objectForKey:@"error"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
            } else {
                // return to InboxViewController through the NavigationController
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }];
    }
}

- (IBAction)signupButton:(UIButton *)sender {

}


@end
