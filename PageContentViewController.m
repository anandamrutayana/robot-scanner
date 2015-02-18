//
//  PageContentViewController.m
//  PageViewDemo
//
//  Created by Simon on 24/11/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import "PageContentViewController.h"
#import "SBUIColor.h"

@interface PageContentViewController ()

@end

@implementation PageContentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.backgroundImageView.image = _image;
    self.subtext.text = self.descriptionText;
    
    self.titleLabel.text = self.titleText;
    
    if( [ self.help.weight isEqualToString:@"bold" ] ){
    
        [self.subtext setFont:[UIFont boldSystemFontOfSize:[self.help.size integerValue] + 5]];
    }
    
    if( [ self.help.justification isEqualToString:@"centre" ] ) {
        self.subtext.textAlignment = NSTextAlignmentCenter;
    }
    
    self.subtext.textColor = [ UIColor colorwithHexString:self.help.color alpha:1 ];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
