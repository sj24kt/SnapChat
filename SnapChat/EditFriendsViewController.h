//
//  EditFriendsTableViewController.h
//  SnapChat
//
//  Created by Sherrie Jones on 2/20/15.
//  Copyright (c) 2015 Sherrie Jones. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface EditFriendsViewController : UITableViewController

@property (strong, nonatomic) NSArray *allUsers;
@property (strong, nonatomic) PFUser *currentUser;
@property (strong, nonatomic) NSMutableArray *friends;

-(BOOL)isFriend:(PFUser *)user;

@end



























