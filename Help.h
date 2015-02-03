//
//  Help.h
//  robots
//
//  Created by Anton McConville on 2015-01-26.
//  Copyright (c) 2015 IBM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Help : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * subtitle;
@property (nonatomic, retain) NSString * image;
@property (nonatomic, retain) NSNumber * screen;
@property (nonatomic, retain) NSString * weight;
@property (nonatomic, retain) NSString * justification;
@property (nonatomic, retain) NSString * size;
@property (nonatomic, retain) NSString * color;

@end
