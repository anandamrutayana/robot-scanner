//
//  ScoreCardData.h
//  robots
//
//  Created by Anton McConville on 2015-01-28.
//  Copyright (c) 2015 IBM. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface ScoreCardData : NSObject

@end


#import <Foundation/Foundation.h>
#import <IBMData/IBMData.h>

@interface RemoteHelp : IBMDataObject <IBMDataObjectSpecialization>

@property(nonatomic, copy) NSMutableDictionary *robot;

@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *timestamp;
@property(nonatomic, copy) NSString *disruptionOrder;
@property(nonatomic, copy) NSString *disruptionSeconds;
@property(nonatomic, copy) NSString *status;

@end
