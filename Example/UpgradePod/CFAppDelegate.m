#import "CFAppDelegate.h"
#import "ConfigService.h"

@implementation CFAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[ConfigService sharedInstance] setupWithUrl:@"" enable:YES];
    NSLog(@"currentVersion:%@", [ConfigService sharedInstance].currentVersion);
    return YES;
}

@end
