//
//  RobotViewController.m
//  robots
//
//  Created by Anton McConville on 2015-01-16.
//  Copyright (c) 2015 IBM. All rights reserved.
//

#import "RobotViewController.h"

@interface RobotViewController ()

@end

@implementation RobotViewController

@synthesize progress;
@synthesize disruptionCode;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    progress=[[UILabel alloc] initWithFrame:CGRectMake(80, 15, 100, 50)];
    progress.textColor=[UIColor colorWithRed:0.82 green:0.337 blue:0 alpha:1]; /*#d15600*/
    [progress setText:@"Time : 0:30"];
    progress.backgroundColor=[UIColor clearColor];
    currMinute=0;
    currSeconds=30;
    
    [ self start ];
}

- (void) viewDidAppear:(BOOL)animated{
    [disruptionCode becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)start
{
    timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
}

-(void)timerFired
{
    if((currMinute>0 || currSeconds>=0) && currMinute>=0)
    {
        if(currSeconds==0)
        {
            currMinute-=1;
            currSeconds=59;
        }
        else if(currSeconds>0)
        {
            currSeconds-=1;
        }
        if(currMinute>-1)
            [progress setText:[NSString stringWithFormat:@"%@%d%@%02d",@"Time : ",currMinute,@":",currSeconds]];
    }
    else
    {
        [timer invalidate];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Celeste caught you!"
                                                        message:@"You've lost a disruption point."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [ self performSegueWithIdentifier:@"returnToScanner" sender:self];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
