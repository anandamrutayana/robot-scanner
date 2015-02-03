//
//  Robot.h
//  robots
//
//  Created by Anton McConville on 2015-02-01.
//  Copyright (c) 2015 IBM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Robot : NSManagedObject

@property (nonatomic, retain) NSString * about;
@property (nonatomic, retain) NSString * clue;
@property (nonatomic, retain) NSNumber * disruption;
@property (nonatomic, retain) NSString * fullshot;
@property (nonatomic, retain) NSString * iBeacon;
@property (nonatomic, retain) NSString * mugshot;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * techZone;
@property (nonatomic, retain) NSString * primaryColor;
@property (nonatomic, retain) NSString * secondaryColor;

@end
