//
//  SecondViewController.h
//  robots
//
//  Created by Anton McConville on 2014-12-31.
//  Copyright (c) 2014 IBM. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MSAnnotatedGauge.h"


@interface SecondViewController : UIViewController{
    IBOutlet UILabel *proximity;
}
@property (nonatomic) MSAnnotatedGauge *annotatedGauge;
@property (nonatomic) NSArray *gauges;
@property (nonatomic) NSTimer *mytimer;
@property (nonatomic, retain) UILabel *proximity;


@end

