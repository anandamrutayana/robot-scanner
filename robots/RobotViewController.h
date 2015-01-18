//
//  RobotViewController.h
//  robots
//
//  Created by Anton McConville on 2015-01-16.
//  Copyright (c) 2015 IBM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RobotViewController : UIViewController <UIAlertViewDelegate>{
    IBOutlet UILabel *progress;
    IBOutlet UITextField *disruptionCode;
    NSTimer *timer;
    int currMinute;
    int currSeconds;
}

@property (nonatomic, retain) UILabel *progress;
@property (nonatomic, retain) UITextField *disruptionCode;

@end
