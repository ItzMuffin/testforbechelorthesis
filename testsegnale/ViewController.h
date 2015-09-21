//
//  ViewController.h
//  testsegnale
//
//  Created by Michele Maffei on 17/09/15.
//  Copyright (c) 2015 Michele Maffei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileWiFi/MobileWiFi.h>
#import <Foundation/Foundation.h>
#import <IOKit/ps/IOPowerSources.h>
#import <IOKit/ps/IOPSKeys.h>
#import <IOKit/pwr_mgt/IOPM.h>
#import <IOKit/IOKitLib.h>

@interface ViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *ampLabel;
@property (strong, nonatomic) IBOutlet UILabel *volLabel;
@property (strong, nonatomic) IBOutlet UILabel *dBmLabel;

@end

