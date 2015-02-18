//
//  ScoreboardViewController.h
//  robots
//
//  Created by Anton McConville on 2015-01-16.
//  Copyright (c) 2015 IBM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"


@interface ScoreboardViewController : UITableViewController /* <UITableViewDelegate, UITableViewDataSource> */

- (NSData *)base64DataFromString;

@property (nonatomic, retain) AppDelegate *appDelegate;

@end
