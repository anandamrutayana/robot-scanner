//
//  AppDelegate.h
//  robots
//
//  Created by Anton McConville on 2014-12-31.
//  Copyright (c) 2014 IBM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Twitter/Twitter.h>
#import "Player.h"
#import "ConfigData.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UIViewController *viewController;

@property (strong, nonatomic) UINavigationController *navController;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) Player *player;
@property (strong, nonatomic) ConfigData *config;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (NSArray*)getRobots;
- (NSArray*)getHelp;

@end

