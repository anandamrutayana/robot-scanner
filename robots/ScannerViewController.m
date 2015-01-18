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

#define kMaxRadius 160


@interface ScannerViewController ()
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
@end


@implementation ScannerViewController

@synthesize proximity;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    ///setup single halo layer
   PulsingHaloLayer *layer = [PulsingHaloLayer layer];
    self.halo = layer;
    self.halo.position = self.beaconView.center;
    [self.view.layer insertSublayer:self.halo below:self.beaconView.layer]; 
    
    
    ///setup multiple halo layer
    //you can specify the number of halos by initial method or by instance property "haloLayerNumber"
//    MultiplePulsingHaloLayer *multiLayer = [[MultiplePulsingHaloLayer alloc] initWithHaloLayerNum:3 andStartInterval:1];
//    self.mutiHalo = multiLayer;
//    self.mutiHalo.position = self.beaconView.center;
//    self.mutiHalo.useTimingFunction = NO;
//    [self.mutiHalo buildSublayers];
//    [self.view.layer insertSublayer:self.mutiHalo below:self.beaconView.layer];
    
    [self setupInitialValues];
    
    
    self.annotatedGauge = [[MSAnnotatedGauge alloc] initWithFrame:CGRectMake(20, 267, 340, 200)];
    self.annotatedGauge.minValue = 0;
    self.annotatedGauge.maxValue = 70;
    self.annotatedGauge.titleLabel.text = @"Proximity to Robot ( metres )";
    self.annotatedGauge.startRangeLabel.text = @"Safe";
    self.annotatedGauge.endRangeLabel.text = @"Danger!";
    self.annotatedGauge.fillArcFillColor = [UIColor colorWithRed:.41 green:.76 blue:.73 alpha:1];
    self.annotatedGauge.fillArcStrokeColor = [UIColor colorWithRed:.41 green:.76 blue:.73 alpha:1];
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
}

-(void)updateGauge
{
    
    
    self.annotatedGauge.value = self.annotatedGauge.value + self.stepper;
    
    proximity.text = [NSString stringWithFormat:@"Proximity: %d metres", 70 - (int)roundf( self.annotatedGauge.value )] ;
    
    if( self.annotatedGauge.value == 45 ){
        
        self.annotatedGauge.value = 30;
        
        self.stepper = 10;
    }
    
    if( self.annotatedGauge.value == 20 ){
        
        self.annotatedGauge.value = 35;
    }
    
    if( self.annotatedGauge.value == 70 ){
        [self.mytimer invalidate]; self.mytimer = nil;
        
         [self performSegueWithIdentifier:@"encounter" sender:self];
    }
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
    
    UIColor *color = [UIColor colorWithRed:self.rSlider.value
                                     green:self.gSlider.value
                                      blue:self.bSlider.value
                                     alpha:1.0];
    
    [self.mutiHalo setHaloLayerColor:color.CGColor];
    [self.halo setBackgroundColor:color.CGColor];
    
    self.rLabel.text = [@(self.rSlider.value) stringValue];
    self.gLabel.text = [@(self.gSlider.value) stringValue];
    self.bLabel.text = [@(self.bSlider.value) stringValue];
}

@end

