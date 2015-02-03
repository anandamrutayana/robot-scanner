//
//  RobotViewController.h
//  robots
//
//  Created by Anton McConville on 2015-01-16.
//  Copyright (c) 2015 IBM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Robot.h"

@interface RobotViewController : UIViewController <UITextViewDelegate, UITextFieldDelegate, UIAlertViewDelegate>{
    IBOutlet UILabel *progress;
    IBOutlet UITextField *disruptionCode;
    IBOutlet UIImageView *robotPic;
    NSTimer *timer;
    int currMinute;
    int currSeconds;
}

@property (nonatomic, retain) UILabel *progress;
@property (nonatomic, retain) UITextField *disruptionCode;
@property (nonatomic, retain) UIImageView *robotPic;
@property (nonatomic) NSNumber *beaconID;
@property (nonatomic) Robot *thisRobot;

- (void)textFieldDidChange;
- (void) setStatus:(NSString*)status;

@end
