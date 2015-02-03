//
//  SBUIColor.h
//  SBI
//
//  Created by Anton McConville on 2014-09-25.
//  Copyright (c) 2014 ShelterBox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIColor (fromHex)
+ (UIColor *)colorwithHexString:(NSString *)hexStr alpha:(CGFloat)alpha;
@end