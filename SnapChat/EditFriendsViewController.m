//
//  EditFriendsTableViewController.m
//  SnapChat
//
//  Created by Sherrie Jones on 2/20/15.
//  Copyright (c) 2015 Sherrie Jones. All rights reserved.
//

#import "EditFriendsViewController.h"

@interface EditFriendsViewController ()

@end

@implementation EditFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // get all the users/friends by default and sort in alphabetical order
    PFQuery *query = [PFUser query];
    [query orderByAscending:@"username"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        } else {
            // store all selected friends in PFUser objects in self.allUsers array
            self.allUsers = objects;
            [self.tableView reloadData]; // reload data after any change
        }
    }];

    self.currentUser = [PFUser currentUser];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.allUsers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    //identifier in TableView Identifier in Utility Panel
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    // get the user for each row and store the name as a textLabel for that row
    PFUser *user = [self.allUsers objectAtIndex:indexPath.row];
    cell.textLabel.text = user.username;

    if ([self isFriend:user]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }

    return cell;
}

// mark row as a friend with checkmark, set currentUser as Parse friend and add to Parse
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // turn off row selection
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];

    // taps on cell - get the cell, the user and the relation for the currentUser
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    // get the user for each row and store the name as a textLabel for that row
    PFUser *user = [self.allUsers objectAtIndex:indexPath.row];
    // add the friend
    PFRelation *friendsRelation = [self.currentUser relationForKey:@"friendsRelation"];

    // is this a friend?
    if ([self isFriend:user]) {
        // hide the checkmark
        cell.accessoryType = UITableViewCellAccessoryNone;
        // remove from the array
        for (PFUser *friend in self.friends) {
            if ([friend.objectId isEqualToString:user.objectId]) {
                [self.friends removeObject:friend];
                break;
            }
        }
        // remove from the friendsRelation
        [friendsRelation removeObject:user];

    } else {
        // this is a friend - add checkmark, add to friends array and add to friendsRelation
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self.friends addObject:user];
        [friendsRelation addObject:user]; // add user to friendsRelation
    }

    // now save on backend in Parse
    [self.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

# pragma mark - Helper Methods

// is called each time a cell is loaded in a view
// return true if a cell is marked as a friend
// Parse creates an objectId for each object stored - unique to each object
-(BOOL)isFriend:(PFUser *)user {

    for (PFUser *friend in self.friends) {
        if ([friend.objectId isEqualToString:user.objectId]) {
            // found a friend
            return YES;
        }
    }
    // not a friend
    return NO;
}

@end


























