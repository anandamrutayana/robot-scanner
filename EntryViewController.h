//
//  EntryViewController.h
//  robots
//
//  Created by Anton McConville on 2015-01-24.
//  Copyright (c) 2015 IBM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageContentViewController.h"

#import <UIKit/UIKit.h>
#import <TwitterKit/TwitterKit.h>

@interface EntryViewController : UIViewController <UIPageViewControllerDataSource>{
    IBOutlet TWTRLogInButton* logInButton;

}

@property (nonatomic, retain) TWTRLogInButton* logInButton;

- (IBAction)startWalkthrough:(id)sender;
@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSArray *pageTitles;
@property (strong, nonatomic) NSArray *pageImages;

@end
