//
//  FirstViewController.h
//  robots
//
//  Created by Anton McConville on 2014-12-31.
//  Copyright (c) 2014 IBM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TwitterKit/TwitterKit.h>

@interface FirstViewController : UIViewController{
    IBOutlet TWTRLogInButton* logInButton;
}

@property (nonatomic, retain) TWTRLogInButton* logInButton;

@end

