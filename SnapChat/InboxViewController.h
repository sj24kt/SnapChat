//
//  InboxViewController.h
//  SnapChat
//
//  Created by Sherrie Jones on 2/19/15.
//  Copyright (c) 2015 Sherrie Jones. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <MediaPlayer/MediaPlayer.h>

@interface InboxViewController : UITableViewController

@property (strong, nonatomic) NSArray *messages;
@property (strong, nonatomic) PFObject *selectedMessages;
@property (strong, nonatomic) MPMoviePlayerController *moviePlayer;

- (IBAction)logoutButton:(UIBarButtonItem *)sender;


@end
