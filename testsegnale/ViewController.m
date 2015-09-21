//
//  ViewController.m
//  testsegnale
//
//  Created by Michele Maffei on 17/09/15.
//  Copyright (c) 2015 Michele Maffei. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(aggregated:) userInfo:nil repeats:YES];
    
    [timer fire];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)aggregated:(NSTimer *)timer
{
    [self readWiFidbm];
    [self batteryStuff];
    
}

-(void)readWiFidbm
{
    WiFiManagerRef manager = WiFiManagerClientCreate(kCFAllocatorDefault, 0);
    CFArrayRef devices = WiFiManagerClientCopyDevices(manager);
    
    WiFiDeviceClientRef client = (WiFiDeviceClientRef)CFArrayGetValueAtIndex(devices, 0);
    CFDictionaryRef data = (CFDictionaryRef)WiFiDeviceClientCopyProperty(client, CFSTR("RSSI"));
    
    CFNumberRef RSSI = (CFNumberRef)CFDictionaryGetValue(data, CFSTR("RSSI_CTL_AGR"));
    
    int raw;
    CFNumberGetValue(RSSI, kCFNumberIntType, &raw);
    
    
    NSLog(@"WiFi signal strength: %d dBm\n", raw);
    self.dBmLabel.text = [NSString stringWithFormat:@"%d dBm", raw];
    
    CFRelease(data);
    CFRelease(devices);
    CFRelease(manager);

}

-(void)batteryStuff
{
    io_service_t powerSource = IOServiceGetMatchingService(kIOMasterPortDefault, IOServiceMatching("IOPMPowerSource"));
    
    if (powerSource) {
        int currentCapacity = -1;
        int maxCapacity = -1;
        int designCapacity = -1;
        int amperage = -1;
        int voltage = -1;
        
        CFNumberRef currentCapacityNum = (CFNumberRef)IORegistryEntryCreateCFProperty(powerSource, CFSTR(kIOPMPSCurrentCapacityKey), kCFAllocatorDefault, 0);
        CFNumberGetValue(currentCapacityNum, kCFNumberIntType, &currentCapacity);
        CFRelease(currentCapacityNum);
        
        CFNumberRef maxCapacityNum = (CFNumberRef)IORegistryEntryCreateCFProperty(powerSource, CFSTR(kIOPMPSMaxCapacityKey), kCFAllocatorDefault, 0);
        CFNumberGetValue(maxCapacityNum, kCFNumberIntType, &maxCapacity);
        CFRelease(maxCapacityNum);
        
        CFNumberRef designCapacityNum = (CFNumberRef)IORegistryEntryCreateCFProperty(powerSource, CFSTR(kIOPMPSDesignCapacityKey), kCFAllocatorDefault, 0);
        CFNumberGetValue(designCapacityNum, kCFNumberIntType, &designCapacity);
        CFRelease(designCapacityNum);
        
//returns 0
        
        CFNumberRef amperageNum = (CFNumberRef)IORegistryEntryCreateCFProperty(powerSource, CFSTR(kIOPMPSAmperageKey), kCFAllocatorDefault, 0);
        CFNumberGetValue(amperageNum, kCFNumberIntType, &amperage);
        CFRelease(amperageNum);
        
        CFNumberRef voltageNum = (CFNumberRef)IORegistryEntryCreateCFProperty(powerSource, CFSTR(kIOPMPSVoltageKey), kCFAllocatorDefault, 0);
        CFNumberGetValue(voltageNum, kCFNumberIntType, &voltage);
        CFRelease(voltageNum);
        
        NSLog(@"Current Capacity - %i mAh",currentCapacity);
        NSLog(@"Max Capacity - %i mAh",maxCapacity);
        NSLog(@"Design Capacity - %i mAh",designCapacity);
        NSLog(@"Percentage - %3.2f%%", (double)currentCapacity/(double)maxCapacity * 100.0f);
        NSLog(@"Voltage - %i mV", voltage);
        self.volLabel.text = [NSString stringWithFormat:@"%i mV", voltage];
        NSLog(@"Amperage - %i mA", amperage);
        self.ampLabel.text = [NSString stringWithFormat:@"%i mA", amperage];
    }
}

@end
