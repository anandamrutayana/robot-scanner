//
//  SecondViewController.m
//  robots
//
//  Created by Anton McConville on 2014-12-31.
//  Copyright (c) 2014 IBM. All rights reserved.
//

#import "ScannerViewController.h"

#import "PulsingHaloLayer.h"
#import "MultiplePulsingHaloLayer.h"
#import "math.h"
#import "ESTBeaconManager.h"
#import "SBUIColor.h"

#import <CoreLocation/CoreLocation.h>
#import <AudioToolbox/AudioServices.h>
#import "AppDelegate.h"
#import "Player.h"
#import "ConfigData.h"

#define kMaxRadius 160


@interface ScannerViewController () <ESTBeaconManagerDelegate>
@property (nonatomic, weak) MultiplePulsingHaloLayer *mutiHalo;
@property (nonatomic, weak) PulsingHaloLayer *halo;
@property (nonatomic, weak) IBOutlet UIImageView *beaconView;
@property (nonatomic, weak) IBOutlet UIImageView *beaconViewMuti;
@property (nonatomic, weak) IBOutlet UISlider *radiusSlider;
@property (nonatomic, weak) IBOutlet UISlider *rSlider;
@property (nonatomic, weak) IBOutlet UISlider *gSlider;
@property (nonatomic, weak) IBOutlet UISlider *bSlider;
@property (nonatomic, weak) IBOutlet UILabel *radiusLabel;
@property (nonatomic, weak) IBOutlet UILabel *rLabel;
@property (nonatomic, weak) IBOutlet UILabel *gLabel;
@property (nonatomic, weak) IBOutlet UILabel *bLabel;

@property (nonatomic, copy)     void (^completion)(ESTBeacon *);
@property (nonatomic, assign)   ESTScanType scanType;

@property (nonatomic, strong) ESTBeacon         *beacon;
@property (nonatomic, strong) ESTBeaconManager  *beaconManager;
@property (nonatomic, strong) ESTBeaconRegion   *beaconRegion;

@property (nonatomic, strong) NSArray *beaconsArray;

@end


@implementation ScannerViewController

@synthesize proximity;
@synthesize rayGun;
@synthesize currentBeacon;

AppDelegate *appDelegate;
NSArray *robots;

CGFloat physicalWidth;
CGFloat physicalHeight;

- (id)initWithBeacon:(ESTBeacon *)beacon
{
    self = [super init];
    if (self)
    {
        self.beacon = beacon;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    appDelegate = [UIApplication sharedApplication].delegate;
    
    robots = [appDelegate getRobots];
    
    self.navigationItem.hidesBackButton = YES;    
    
    [self.parentViewController.navigationItem setTitle:@"Title"];
    
    self.THEME_COLOR = [ UIColor colorwithHexString:@"7dcfb6" alpha:1];
    
    ///setup single halo layer
   PulsingHaloLayer *layer = [PulsingHaloLayer layer];
    self.halo = layer;
    
    CGFloat scale = [UIScreen mainScreen].scale;
    CGRect screenRect = [[UIScreen mainScreen] bounds];
        
    physicalWidth = screenRect.size.width * scale;
    physicalHeight = screenRect.size.height * scale;
    
    NSArray *points = [NSArray arrayWithObjects:
                       [NSValue valueWithCGPoint:CGPointMake( physicalWidth / ( scale * 2 ), 150)],
                       [NSValue valueWithCGPoint:CGPointMake(7.7, 8.8)],
                       nil];
    
    self.halo.position = [[points objectAtIndex:0] CGPointValue];

    [self.view.layer insertSublayer:self.halo below:self.beaconView.layer];
    
    
    [self setupInitialValues];
    
    self.annotatedGauge = [[MSAnnotatedGauge alloc] initWithFrame:CGRectMake( ( physicalWidth / ( scale * 2 ) ) - 130, 230, 260, 200 ) ];
    self.annotatedGauge.minValue = 0;
    self.annotatedGauge.maxValue = [ appDelegate.config.scannerWidth integerValue ];
    self.annotatedGauge.titleLabel.text = @"Proximity to Robot ( metres )";
    self.annotatedGauge.startRangeLabel.text = @"Far";
    self.annotatedGauge.endRangeLabel.text = @"Close";
    self.annotatedGauge.fillArcFillColor = self.THEME_COLOR;
    self.annotatedGauge.fillArcStrokeColor = self.THEME_COLOR;
    self.annotatedGauge.value =  0;
    [self.view addSubview:self.annotatedGauge];
    
    self.annotatedGauge.backgroundColor = [UIColor clearColor];
    
    self.gauges = @[self.annotatedGauge];

    
   
    self.stepper = 5;
    
    
    
    self.beaconManager = [[ESTBeaconManager alloc] init];
    self.beaconManager.delegate = self;
    

    self.beaconRegion = [[ESTBeaconRegion alloc] initWithProximityUUID:self.beacon.proximityUUID
                                                                 major:[self.beacon.major unsignedIntegerValue]
                                                                 minor:[self.beacon.minor unsignedIntegerValue]
                                                            identifier:@"RegionIdentifier"
                                                               secured:self.beacon.isSecured];
    
    
    
    self.beaconRegion = [[ESTBeaconRegion alloc] initWithProximityUUID:ESTIMOTE_PROXIMITY_UUID identifier:@"EstimoteSampleRegion"];
    
    
    self.scanType = ESTScanTypeBeacon;
    
    if (self.scanType == ESTScanTypeBeacon)
    {
        [self.beaconManager startEstimoteBeaconsDiscoveryForRegion:self.beaconRegion];
        [self.beaconManager startRangingBeaconsInRegion:self.beaconRegion];
        [self startRangingBeacons];
    }
    else
    {
        
        [self startRangingBeacons];
        
        [self.beaconManager startRangingBeaconsInRegion:self.beaconRegion];
        
        [self.beaconManager startEstimoteBeaconsDiscoveryForRegion:self.beaconRegion];
    }
}

- (void)beaconManager:(ESTBeaconManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (self.scanType == ESTScanTypeBeacon)
    {
        [self startRangingBeacons];
    }
}

-(void)startRangingBeacons
{
    if ([ESTBeaconManager authorizationStatus] == kCLAuthorizationStatusNotDetermined)
    {
        if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
            /*
             * No need to explicitly request permission in iOS < 8, will happen automatically when starting ranging.
             */
            [self.beaconManager startRangingBeaconsInRegion:self.beaconRegion];
        } else {
            /*
             * Request permission to use Location Services. (new in iOS 8)
             * We ask for "always" authorization so that the Notification Demo can benefit as well.
             * Also requires NSLocationAlwaysUsageDescription in Info.plist file.
             *
             * For more details about the new Location Services authorization model refer to:
             * https://community.estimote.com/hc/en-us/articles/203393036-Estimote-SDK-and-iOS-8-Location-Services
             */
            
//            NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
//            [[UIApplication sharedApplication] openURL:settingsURL];
            
            [self.beaconManager requestAlwaysAuthorization];
            [self.beaconManager requestWhenInUseAuthorization];
        }
    }
    else if([ESTBeaconManager authorizationStatus] == kCLAuthorizationStatusAuthorized)
    {
        [self.beaconManager startRangingBeaconsInRegion:self.beaconRegion];
    }
    else if([ESTBeaconManager authorizationStatus] == kCLAuthorizationStatusDenied)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location Access Denied"
                                                        message:@"You have denied access to location services. Change this in app settings."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        
        [alert show];
    }
    else if([ESTBeaconManager authorizationStatus] == kCLAuthorizationStatusRestricted)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location Not Available"
                                                        message:@"You have no access to location services."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        
        [alert show];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    /*
     *Stops ranging after exiting the view.
     */
    [self.beaconManager stopRangingBeaconsInRegion:self.beaconRegion];
    [self.beaconManager stopEstimoteBeaconDiscovery];
}

- (void)dismiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - ESTBeaconManager delegate

- (void)beaconManager:(ESTBeaconManager *)manager rangingBeaconsDidFailForRegion:(ESTBeaconRegion *)region withError:(NSError *)error
{
  /*  UIAlertView* errorView = [[UIAlertView alloc] initWithTitle:@"Ranging error"
                                                        message:error.localizedDescription
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    
    [errorView show];*/
}

- (void)beaconManager:(ESTBeaconManager *)manager monitoringDidFailForRegion:(ESTBeaconRegion *)region withError:(NSError *)error
{
    UIAlertView* errorView = [[UIAlertView alloc] initWithTitle:@"Monitoring error"
                                                        message:error.localizedDescription
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    
    [errorView show];
}


- (void)beaconManager:(ESTBeaconManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(ESTBeaconRegion *)region
{
    self.beaconsArray = beacons;
    
    ESTBeacon *firstBeacon = [beacons firstObject];
    
    double distance = [ firstBeacon.distance doubleValue ];
    
    currentBeacon = [beacons firstObject];
    
    double disruptionRange = [ appDelegate.config.disruptionRange doubleValue ];
    
    if( [self checkIfWanted:currentBeacon ] ){
    
        if( distance > 0 ){
        
            if( distance > disruptionRange ){
    
                proximity.text = [NSString stringWithFormat:@"%@", [self textForProximity:firstBeacon.proximity] ] ;
                self.annotatedGauge.value = self.annotatedGauge.maxValue - (int) distance;
        
            }else{
            
            
                [self.beaconManager stopRangingBeaconsInRegion:self.beaconRegion];
            
                AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            
                [self performSegueWithIdentifier:@"encounter" sender:self];
            }
        }
    }
}

- (BOOL) checkIfWanted:(ESTBeacon *)beacon{
    
    BOOL outcome = TRUE;
    
    Player* player = appDelegate.player;
    
    /* Seems a slow way of managing this ... */
    
    /* For all this player's robots ... */
    
    for( int count = 0; count < player.robots.count; count++ ){
        
        NSMutableDictionary *scoreData = [ player.robots objectAtIndex:count ];
        
        NSString* status = [scoreData objectForKey:@"status" ];
        
        /* Find the robots that this player has disrupted ... */
        
        if( [status isEqualToString: @"disrupted" ] || [status isEqualToString: @"failed" ]  ){
            
            NSString* robotName = [scoreData objectForKey:@"name" ];
            
            /* Check if the current beacon is one of the disrupted robots ... */
            
            for( int r = 0; r < robots.count; r++ ){
                
                Robot* robot = [ robots objectAtIndex:r ];
                
                if( [robotName isEqualToString: robot.name] ){
                    
                    if( [ robot.iBeacon isEqualToString: [ currentBeacon.minor stringValue ] ] ){
                        
                        NSLog( @"DISRUPTED ROBOT BLOCKED: %@", robot.name );
                        
                        outcome = FALSE;
                        break;
                    }
                }
            }
        }
    }
    
    return outcome;
}

- (NSString *)textForProximity:(CLProximity)proximity
{
    switch (proximity) {
        case CLProximityFar:
            return @"Robot in range";
            break;
        case CLProximityNear:
            return @"Robot is close by";
            break;
        case CLProximityImmediate:
            return @"Robot in sight";
            break;
            
        default:
            return @"No robots in range";
            break;
    }
}


- (void)beaconManager:(ESTBeaconManager *)manager didDiscoverBeacons:(NSArray *)beacons inRegion:(ESTBeaconRegion *)region
{
    self.beaconsArray = beacons;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// =============================================================================
#pragma mark - Private

- (void)setupInitialValues {
    
    self.radiusSlider.value = 2;
//    [self radiusChanged:nil];
    
    self.rSlider.value = 0;
    self.gSlider.value = 0.487;
    self.bSlider.value = 1.0;
//    [self colorChanged:nil];
}


// =============================================================================
#pragma mark - IBAction

- (IBAction)radiusChanged:(UISlider *)sender {
    
    self.mutiHalo.radius = self.radiusSlider.value * kMaxRadius;
    self.halo.radius = self.radiusSlider.value * kMaxRadius;
    
    self.radiusLabel.text = [@(self.radiusSlider.value) stringValue];
}

- (IBAction)colorChanged:(UISlider *)sender {

    
    [self.mutiHalo setHaloLayerColor:CFBridgingRetain(self.THEME_COLOR)];
    [self.halo setBackgroundColor:CFBridgingRetain(self.THEME_COLOR)];
    
    self.rLabel.text = [@(self.rSlider.value) stringValue];
    self.gLabel.text = [@(self.gSlider.value) stringValue];
    self.bLabel.text = [@(self.bSlider.value) stringValue];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
        RobotViewController *controller = (RobotViewController *)segue.destinationViewController;
    
        controller.beaconID = currentBeacon.minor;
    
}


@end

