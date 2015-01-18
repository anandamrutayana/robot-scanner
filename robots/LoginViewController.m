//
//  FirstViewController.m
//  robots
//
//  Created by Anton McConville on 2014-12-31.
//  Copyright (c) 2014 IBM. All rights reserved.
//

#import "LoginViewController.h"

#import <Foundation/Foundation.h>

#import <IBMBluemix/IBMBluemix.h>
#import <IBMPush/IBMPush.h>
#import <IBMData/IBMData.h>


#import "Player.h"


@interface LoginViewController ()

@end

@implementation LoginViewController

@synthesize logInButton;

- (void)viewDidLoad {
    
    [IBMBluemix initializeWithApplicationId: @"4108d6c9-4b48-430f-a538-ab0c33b04f2e"
                       andApplicationSecret: @"09467e9e5accd44d1186667563cec0f46b07a9e4"
                        andApplicationRoute: @"robot.mybluemix.net"];
    
    [IBMData initializeService];

    
    TWTRLogInButton* newlogInButton =  [TWTRLogInButton
                                     buttonWithLogInCompletion:
                                     ^(TWTRSession* session, NSError* error) {
                                         if (session) {
                                             
                                             NSLog(@"signed in as %@", [session userName]);
                                             
                                             IBMQuery *qry = [Player query];
                                             
                                             [[qry find] continueWithBlock:^id(BFTask *task) {
                                                 if(task.error) {
                                                     NSLog(@"listItems failed with error: %@", task.error);
                                                 } else {
                                                     
                                                     BOOL playerFound = false;
                                                     
                                                     NSMutableArray* playerList = [NSMutableArray arrayWithArray: task.result];
                                                     
                                                     for( Player* player in playerList ){
                                                         
                                                         if( [ player.name isEqualToString: [ session userName ] ]){
                                                             
                                                             /* Player has played before - so we don't need to make a new
                                                                accound for them */
                                                             
                                                             NSLog( @"PLAYER FOUND" );
                                                             
                                                             playerFound = true;
                                                             
                                                             [self performSegueWithIdentifier:@"scanSegue" sender:self];
                                                             
                                                         }
                                                     }
                                                     
                                                     if( playerFound == false ){
                                                         
                                                         /* create a player account */
                                                         
                                                         Player* newPlayer = [[Player alloc] init];
                                                         
                                                         newPlayer.name = [ session userName ];
                                                         newPlayer.robots = [[NSArray alloc] init ];
                                                         
                                                         
                                                         [[newPlayer save] continueWithBlock:^id(BFTask *task) {
                                                             if(task.error) {
                                                                 NSLog(@"createItem failed with error: %@", task.error);
                                                             }
                                                             
                                                             [self performSegueWithIdentifier:@"scanSegue" sender:self];
                                                             
                                                             return nil;
                                                         }];
                                                     }
                                                 }
                                                 return nil;
                                                 
                                             }];
                                             
                                         } else {
                                             NSLog(@"error: %@", [error localizedDescription]);
                                         }
                                     }];
    
    logInButton.logInCompletion = newlogInButton.logInCompletion;

    
    [super viewDidLoad];

    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
