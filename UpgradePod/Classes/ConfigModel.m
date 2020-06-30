#import "ConfigModel.h"

@implementation ConfigModel

- (BOOL)hasNewVersion:(NSString *)marketingVersion {
    NSArray *marketingArray = [marketingVersion componentsSeparatedByString:@"."];
    NSArray *versionArray = [_version componentsSeparatedByString:@"."];
    for (int i = 0; i< versionArray.count; i++) {
        NSInteger a = [[versionArray objectAtIndex:i] integerValue];
        if (i >= marketingArray.count) {
            return YES;
        }
        NSInteger b = [[marketingArray objectAtIndex:i] integerValue];
        if (a > b) {
            return YES;
        } else if (a < b) {
            return NO;
        }
    }
    return NO;
}

- (BOOL)isUpgradeNormal {
    return _updateState == 0;
}

- (BOOL)isUpgradeForce {
    return _updateState == 1;
}

@end
