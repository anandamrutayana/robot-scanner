//
//  FirstViewController.m
//  robots
//
//  Created by Anton McConville on 2014-12-31.
//  Copyright (c) 2014 IBM. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

@synthesize logInButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    
   logInButton =  [TWTRLogInButton buttonWithLogInCompletion:
                                     ^(TWTRSession* session, NSError* error) {
                                         if (session) {
                                             NSLog(@"signed in as %@", [session userName]);
                                         } else {
                                             NSLog(@"error: %@", [error localizedDescription]);
                                         }
                                     }];
    logInButton.center = self.view.center;
//    [self.view addSubview:logInButton];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
