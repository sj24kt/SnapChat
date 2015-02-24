//
//  ImageViewController.h
//  SnapChat
//
//  Created by Sherrie Jones on 2/23/15.
//  Copyright (c) 2015 Sherrie Jones. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface ImageViewController : UIViewController

@property (strong, nonatomic) PFObject *message;

@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@end
