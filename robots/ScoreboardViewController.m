//
//  ScoreboardViewController.m
//  robots
//
//  Created by Anton McConville on 2015-01-16.
//  Copyright (c) 2015 IBM. All rights reserved.
//

#import "ScoreboardViewController.h"
#import "Robot.h"
#import "SBUIColor.h"

@interface ScoreboardViewController ()

@end

@implementation ScoreboardViewController

@synthesize appDelegate;

NSArray *tableData;

NSArray *robots;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
      
    appDelegate = [UIApplication sharedApplication].delegate;
    robots = [appDelegate getRobots];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    tableView.layer.borderColor = [UIColor colorwithHexString:@"00b2ca" alpha:1 ].CGColor;
    return [robots count];
}

 - (UITableViewCell *)tableView: (UITableView *)tableView cellForRowAtIndexPath: (NSIndexPath *)indexPath {
     
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"robotCell"];
     
     Robot *robot = [robots objectAtIndex:indexPath.row];
     
     UILabel *lblName = (UILabel *)[cell viewWithTag:100];
     [lblName setText: robot.name];
     lblName.textColor = [UIColor colorwithHexString: robot.primaryColor alpha:1 ];
     
     UILabel *lblPoints = (UILabel *)[cell viewWithTag:900];
     lblPoints.textColor = [UIColor colorwithHexString: robot.primaryColor alpha:1 ];
     
     NSData* imageData = [ self base64DataFromString: robot.mugshot ];
     
     UIImageView *imageView = (UIImageView *)[cell viewWithTag:300];
     
     imageView.image = [UIImage imageWithData:imageData];
     
     Player* player = self.appDelegate.player;
     
     /* Seems a slow way of managing this ... */
     
     for( int count = 0; count < player.robots.count; count++ ){
         
         NSMutableDictionary *scoreData = [ player.robots objectAtIndex:count ];
         
         NSString* robotName = [scoreData objectForKey:@"name" ];
         
         if( [robotName isEqualToString: robot.name ]  ){
             
             NSString* status = [scoreData objectForKey:@"status"];
             
             UILabel *statusLabel = (UILabel *)[cell viewWithTag:500];
             [statusLabel setText: status ];
             
             statusLabel.textColor = [UIColor colorwithHexString: robot.primaryColor alpha:1 ];
             
             NSString* score = @"0";
             
             if( [ status isEqualToString:@"disrupted"] ){
                 score = @"1";
             }
             
             UILabel *pointsLabel = (UILabel *)[cell viewWithTag:700];
             [pointsLabel setText: score ];
             pointsLabel.textColor = [UIColor colorwithHexString: robot.primaryColor alpha:1 ];
             
             break;
         }
     }
     
     [cell.contentView.layer setBorderColor:[UIColor colorwithHexString: robot.primaryColor alpha:1 ].CGColor];
     
     return cell; }


- (UIImage *)imageResize :(UIImage*)img andResizeTo:(CGSize)newSize
{
    CGFloat scale = [[UIScreen mainScreen]scale];
    /*You can remove the below comment if you dont want to scale the image in retina   device .Dont forget to comment UIGraphicsBeginImageContextWithOptions*/
    //UIGraphicsBeginImageContext(newSize);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, scale);
    [img drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (NSData *)base64DataFromString: (NSString *)string
{
    unsigned long ixtext, lentext;
    unsigned char ch, inbuf[4], outbuf[3];
    short i, ixinbuf;
    Boolean flignore, flendtext = false;
    const unsigned char *tempcstring;
    NSMutableData *theData;
    
    if (string == nil)
    {
        return [NSData data];
    }
    
    ixtext = 0;
    
    tempcstring = (const unsigned char *)[string UTF8String];
    
    lentext = [string length];
    
    theData = [NSMutableData dataWithCapacity: lentext];
    
    ixinbuf = 0;
    
    while (true)
    {
        if (ixtext >= lentext)
        {
            break;
        }
        
        ch = tempcstring [ixtext++];
        
        flignore = false;
        
        if ((ch >= 'A') && (ch <= 'Z'))
        {
            ch = ch - 'A';
        }
        else if ((ch >= 'a') && (ch <= 'z'))
        {
            ch = ch - 'a' + 26;
        }
        else if ((ch >= '0') && (ch <= '9'))
        {
            ch = ch - '0' + 52;
        }
        else if (ch == '+')
        {
            ch = 62;
        }
        else if (ch == '=')
        {
            flendtext = true;
        }
        else if (ch == '/')
        {
            ch = 63;
        }
        else
        {
            flignore = true;
        }
        
        if (!flignore)
        {
            short ctcharsinbuf = 3;
            Boolean flbreak = false;
            
            if (flendtext)
            {
                if (ixinbuf == 0)
                {
                    break;
                }
                
                if ((ixinbuf == 1) || (ixinbuf == 2))
                {
                    ctcharsinbuf = 1;
                }
                else
                {
                    ctcharsinbuf = 2;
                }
                
                ixinbuf = 3;
                
                flbreak = true;
            }
            
            inbuf [ixinbuf++] = ch;
            
            if (ixinbuf == 4)
            {
                ixinbuf = 0;
                
                outbuf[0] = (inbuf[0] << 2) | ((inbuf[1] & 0x30) >> 4);
                outbuf[1] = ((inbuf[1] & 0x0F) << 4) | ((inbuf[2] & 0x3C) >> 2);
                outbuf[2] = ((inbuf[2] & 0x03) << 6) | (inbuf[3] & 0x3F);
                
                for (i = 0; i < ctcharsinbuf; i++)
                {
                    [theData appendBytes: &outbuf[i] length: 1];
                }
            }
            
            if (flbreak)
            {
                break;
            }
        }
    }
    
    return theData;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.0;
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
