//
//  SecondViewController.h
//  robots
//
//  Created by Anton McConville on 2014-12-31.
//  Copyright (c) 2014 IBM. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "MSAnnotatedGauge.h"
#import "ESTBeaconManager.h"
#import "ESTBeaconRegion.h"
#import "RobotViewController.h"


@interface ScannerViewController : UIViewController{
    IBOutlet UILabel *proximity;
   }
@property (nonatomic) MSAnnotatedGauge *annotatedGauge;
@property (nonatomic) NSArray *gauges;
@property (nonatomic) NSTimer *mytimer;
@property (nonatomic, retain) UILabel *proximity;
@property (nonatomic) int stepper;
@property (nonatomic) UIColor* THEME_COLOR;

- (id)initWithBeacon:(ESTBeacon *)beacon;

typedef enum : int
{
    ESTScanTypeBluetooth,
    ESTScanTypeBeacon
    
} ESTScanType;

@property (nonatomic) ESTBeacon *currentBeacon;


@end

