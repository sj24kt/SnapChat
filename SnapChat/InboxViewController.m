//
//  InboxViewController.m
//  SnapChat
//
//  Created by Sherrie Jones on 2/19/15.
//  Copyright (c) 2015 Sherrie Jones. All rights reserved.
//

#import "InboxViewController.h"
#import "ImageViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface InboxViewController ()

@end

@implementation InboxViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.moviePlayer = [[MPMoviePlayerController alloc] init];

    PFUser *currentUser = [PFUser currentUser];
    // if currentUser show username
    if (currentUser) {
        //NSLog(@"Current User: %@", currentUser.username);
    } else {
        // otherwise always display login screen on first visit
        [self performSegueWithIdentifier:@"showLogin" sender:self];
    }
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    // find all messages only for the current user
    PFQuery *query = [PFQuery queryWithClassName:@"Messages"];
    [query whereKey:@"recipientsIds" equalTo:[[PFUser currentUser] objectId]];
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        } else {
            // we found messages!
            // save messages found in Parse objects array to our messages array
            self.messages = objects;
            [self.tableView reloadData];
            //NSLog(@"Retrieved %lu messages", (unsigned long)[self.messages count]);
        }
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.messages count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    // get current message and display the sender's name on table row
    PFObject *message = [self.messages objectAtIndex:indexPath.row];
    cell.textLabel.text = [message objectForKey:@"senderName"];

    // display appropriate image or video icon
    NSString *fileType = [message objectForKey:@"fileType"];
    if ([fileType isEqualToString:@"image"]) {
        cell.imageView.image = [UIImage imageNamed:@"icon_image"];
    } else {
        cell.imageView.image = [UIImage imageNamed:@"icon_video"];
    }

    return cell;
}
#pragma mark - Table view data source

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    self.selectedMessages = [self.messages objectAtIndex:indexPath.row];

    // display appropriate image or video icon
    NSString *fileType = [self.selectedMessages objectForKey:@"fileType"];
    if ([fileType isEqualToString:@"image"]) {
        [self performSegueWithIdentifier:@"showImage" sender:self];
    } else {
        PFFile *videoFile = [self.selectedMessages objectForKey:@"file"];
        NSURL *fileUrl = [NSURL URLWithString:videoFile.url];
        self.moviePlayer.contentURL = fileUrl;
        [self.moviePlayer prepareToPlay];
        // calls thumbnailFromVideoAtURL method to show first video frame

        // add it to the view controller so we can see it
        [self.view addSubview:self.moviePlayer.view];
        [self.moviePlayer setFullscreen:YES animated:YES];
    }

    // delete it!
    NSMutableArray *recipientIds = [NSMutableArray arrayWithArray:[self.selectedMessages objectForKey:@"recipientIds"]];
    NSLog(@"Recipients: %@", recipientIds);

    // delete messages from Parse
    if ([recipientIds count] == 1) {
        // last recipient - ok to delete it
        [self.selectedMessages deleteInBackground];
    } else {
        // remove the recipient and save it locally
        [recipientIds removeObject:[[PFUser currentUser] objectId]];
        [self.selectedMessages setObject:recipientIds forKey:@"recipientIds"];
        [self.selectedMessages saveInBackground];
    }
}

#pragma mark - IBAction Buttons

- (IBAction)logoutButton:(UIBarButtonItem *)sender {
    // log current user out of app and return to the login window
    [PFUser logOut];
    [self performSegueWithIdentifier:@"showLogin" sender:self];
}

#pragma mark - Table view segue

// call seque to remove bottom tab bar from login/signup screens to prevent access to entire app
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showLogin"]) {
        [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
    } else if ([segue.identifier isEqualToString:@"showImage"]) {
        [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
        ImageViewController *imageViewController = (ImageViewController *)segue.destinationViewController;
        imageViewController.message = self.selectedMessages;
    }
}

# pragma mark - Helper methods

- (UIImage *)thumbnailFromVideoAtURL:(NSURL *)url
{
    AVAsset *asset = [AVAsset assetWithURL:url];

    //  Get thumbnail at the very start of the video
    CMTime thumbnailTime = [asset duration];
    thumbnailTime.value = 0;

    //  Get image from the video at the given time
    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];

    CGImageRef imageRef = [imageGenerator copyCGImageAtTime:thumbnailTime actualTime:NULL error:NULL];
    UIImage *thumbnail = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);

    return thumbnail;
}

@end
