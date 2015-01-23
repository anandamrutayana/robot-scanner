//
//  FirstViewController.h
//  robots
//
//  Created by Anton McConville on 2014-12-31.
//  Copyright (c) 2014 IBM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TwitterKit/TwitterKit.h>
#import <CoreLocation/CoreLocation.h>

@interface LoginViewController : UIViewController <CLLocationManagerDelegate>{
    IBOutlet TWTRLogInButton* logInButton;
}

@property (nonatomic, retain) TWTRLogInButton* logInButton;
@property (strong, nonatomic) CLLocationManager *locationManager;

@end

