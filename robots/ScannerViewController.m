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

#import <CoreLocation/CoreLocation.h>


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
@synthesize currentBeacon;

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
    
    [self.parentViewController.navigationItem setTitle:@"Title"];
    
//    [UIColor colorWithRed:.41 green:.76 blue:.73 alpha:1];
    
    self.THEME_COLOR = [UIColor colorWithRed:0.09 green:0.729 blue:0.608 alpha:1];
    
    ///setup single halo layer
   PulsingHaloLayer *layer = [PulsingHaloLayer layer];
    self.halo = layer;
    self.halo.position = self.beaconView.center;
    [self.view.layer insertSublayer:self.halo below:self.beaconView.layer]; 
    
    
    
    [self setupInitialValues];
    
    
    self.annotatedGauge = [[MSAnnotatedGauge alloc] initWithFrame:CGRectMake(20, 267, 340, 200)];
    self.annotatedGauge.minValue = 0;
    self.annotatedGauge.maxValue = 20;
    self.annotatedGauge.titleLabel.text = @"Proximity to Robot ( metres )";
    self.annotatedGauge.startRangeLabel.text = @"Far";
    self.annotatedGauge.endRangeLabel.text = @"Close";
    self.annotatedGauge.fillArcFillColor = self.THEME_COLOR;
    self.annotatedGauge.fillArcStrokeColor = self.THEME_COLOR;
    self.annotatedGauge.value =  0;
    [self.view addSubview:self.annotatedGauge];
    
    self.annotatedGauge.backgroundColor = [UIColor clearColor];
    
    self.gauges = @[self.annotatedGauge];

    
    self.mytimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                     target:self
                                   selector:@selector(updateGauge)
                                   userInfo:nil
                                    repeats:YES];
    
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
    UIAlertView* errorView = [[UIAlertView alloc] initWithTitle:@"Ranging error"
                                                        message:error.localizedDescription
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    
    [errorView show];
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
    
    NSLog( @"UUID: %@", firstBeacon.proximityUUID );
    
    double distance = [ firstBeacon.distance doubleValue ];
                       
    NSLog( @"RAW DISTANCE: %f", distance );
    
    if( distance > 0 ){
        
        if( distance > 2 ){
    
            proximity.text = [NSString stringWithFormat:@"%@", [self textForProximity:firstBeacon.proximity] ] ;
    
            self.annotatedGauge.value = self.annotatedGauge.maxValue - (int) distance;
        }else{
            
            currentBeacon = [beacons firstObject];
            
          [self performSegueWithIdentifier:@"encounter" sender:self];
        }
    }
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

-(void)updateGauge
{
    
    
//    self.annotatedGauge.value = self.annotatedGauge.value + self.stepper;
    
//    proximity.text = [NSString stringWithFormat:@"Proximity: %d metres", 70 - (int)roundf( self.annotatedGauge.value )] ;
    
//    if( self.annotatedGauge.value == 45 ){
//        
//        self.annotatedGauge.value = 30;
//        
//        self.stepper = 10;
//    }
//    
//    if( self.annotatedGauge.value == 20 ){
//        
//        self.annotatedGauge.value = 35;
//    }
//    
//    if( self.annotatedGauge.value == 70 ){
//        [self.mytimer invalidate]; self.mytimer = nil;
//        
//         [self performSegueWithIdentifier:@"encounter" sender:self];
//    }
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

