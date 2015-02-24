//
//  ImageViewController.m
//  SnapChat
//
//  Created by Sherrie Jones on 2/23/15.
//  Copyright (c) 2015 Sherrie Jones. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController ()

@end

@implementation ImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // get the image url from the current Parse message and display it
    PFFile *imageFile = [self.message objectForKey:@"file"];
    NSURL *imageFileUrl = [[NSURL alloc] initWithString:imageFile.url];
    NSData *imageData = [NSData dataWithContentsOfURL:imageFileUrl];
    self.imageView.image = [UIImage imageWithData:imageData];

    // set the navigation title with sender's name
    NSString *senderName = [self.message objectForKey:@"senderName"];
    NSString *title = [NSString stringWithFormat:@"Sent from %@", senderName];
    self.navigationItem.title = title;

}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    if ([self respondsToSelector:@selector(timeout)]) {
        [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(timeout) userInfo:nil repeats:NO];
    } else {
        NSLog(@"Error: selector missing!");
    }

}

-(void)timeout {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
















