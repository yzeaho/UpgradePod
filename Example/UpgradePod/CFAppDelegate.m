//
//  CFAppDelegate.m
//  UpgradePod
//
//  Created by yzeaho on 06/29/2020.
//  Copyright (c) 2020 yzeaho. All rights reserved.
//

#import "CFAppDelegate.h"
#import "ConfigService.h"

@implementation CFAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSLog(@"%ld", DDLogLevelVerbose);
    NSLog(@"%ld", DDLogLevelDebug);
    NSLog(@"%ld", ddLogLevel);
    DDOSLogger *logger = [DDOSLogger sharedInstance];
    [DDLog addLogger:logger]; // Uses os_log
    [[ConfigService sharedInstance] config:@"https://biz-dev.szse.cn:8289/wapp/native/ios_app_config.json" enable:YES];
    DDLogDebug(@"currentVersion:%@", [ConfigService sharedInstance].currentVersion);
    
    return YES;
}

@end
