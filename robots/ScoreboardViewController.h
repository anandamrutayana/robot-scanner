//
//  ScoreboardViewController.h
//  robots
//
//  Created by Anton McConville on 2015-01-16.
//  Copyright (c) 2015 IBM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScoreboardViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

- (NSData *)base64DataFromString;

@end
