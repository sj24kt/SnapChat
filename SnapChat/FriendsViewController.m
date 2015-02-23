//
//  FriendsViewController.m
//  SnapChat
//
//  Created by Sherrie Jones on 2/21/15.
//  Copyright (c) 2015 Sherrie Jones. All rights reserved.
//

#import "FriendsViewController.h"
#import "EditFriendsViewController.h"

@interface FriendsViewController ()

@end

@implementation FriendsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // set the friendsRelation by getting the currentUsers relationship in Parse
    self.friendsRelation = [[PFUser currentUser] objectForKey:@"friendsRelation"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    // get a list of all friends checked & stored in an array
    PFQuery *query = [self.friendsRelation query];

    // sort list in alphabetical order by username
    [query orderByAscending:@"username"];

    // execute the query by saving objects array and reload table data
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        } else {
            // save the objects array as the datasource for the tableView
            self.friends = objects;
            [self.tableView reloadData];
        }
    }];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showEditFriends"]) {
        // cast segue for specific viewController
        EditFriendsViewController *editFriendsViewController = (EditFriendsViewController *)segue.destinationViewController;

        // set VC properties - store NSArray to new NSMutableArray
        editFriendsViewController.friends = [NSMutableArray arrayWithArray:self.friends];
        
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.friends count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    // get current user based on indexPath and set the cell's textLabel
    PFUser *user = [self.friends objectAtIndex:indexPath.row];
    cell.textLabel.text = user.username;

    return cell;
}


@end



























