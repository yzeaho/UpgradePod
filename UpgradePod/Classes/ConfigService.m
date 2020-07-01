#import "ConfigService.h"
#import "ConfigModel.h"
#import <CocoaLumberjack/CocoaLumberjack.h>
#import <AFNetworking/AFNetworking.h>
#import <MJExtension/MJExtension.h>

@interface ConfigService ()

@property (nonatomic, strong) NSMutableArray *callbackList;
@property (nonatomic, strong) ConfigModel *model;
@property (nonatomic, assign) BOOL shown;
@property (nonatomic, assign) BOOL started;
@property (nonatomic, assign) BOOL enable;
@property (nonatomic, strong) NSDate *successDate;
@property (nonatomic, strong) NSString *configUrl;

@end

static const DDLogLevel ddLogLevel = DDLogLevelDebug;

@implementation ConfigService

+ (instancetype)sharedInstance {
    static ConfigService *service = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        service = [[ConfigService alloc] init];
    });
    return service;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        NSDictionary *infoPlist = [[NSBundle mainBundle] infoDictionary];
        _currentVersion = [infoPlist objectForKey:@"CFBundleVersion"];
        _marketingVersion = [infoPlist objectForKey:@"CFBundleShortVersionString"];
        _callbackList = [[NSMutableArray alloc] init];
        _shown = false;
    }
    return self;
}

- (void)config:(NSString *)url enable:(BOOL)enable {
    _configUrl = url;
    _enable = enable;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidBecomeActiveNotification)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
}

- (void)addCallback:(id<ConfigCallback>)callback {
    DDLogDebug(@"%@", callback);
    [self.callbackList addObject:callback];
    [callback configNotifyChange];
}

- (void)removeCallback:(id<ConfigCallback>)callback {
    DDLogDebug(@"%@", callback);
    [self.callbackList removeObject:callback];
}

- (void)applicationDidBecomeActiveNotification {
    DDLogDebug(@"applicationDidBecomeActiveNotification");
    if (!self.enable) {
        DDLogDebug(@"Feature not available");
        return;
    }
    if (self.started) {
        DDLogDebug(@"Already started to acquire");
        return;
    }
    if (self.successDate) {
        NSTimeInterval interval = ABS([self.successDate timeIntervalSinceNow]);
        DDLogDebug(@"timeIntervalSinceNow %f", interval);
        if (interval < 1800) {
            for (id<ConfigCallback> delegate in self.callbackList) {
                [delegate configNotifyChange];
            }
            return;
        }
    }
    [self fetch];
}

- (void)fetch {
    if (!_configUrl) {
        DDLogWarn(@"configUrl is nil");
        return;
    }
    DDLogInfo(@"fetch app config from server start");
    self.started = true;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"application/json", @"text/json", @"text/javascript", nil];
    DDLogInfo(@"url %@", _configUrl);
    [manager GET:_configUrl parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        if (!responseObject || ![responseObject isKindOfClass:[NSDictionary class]]) {
            DDLogWarn(@"error server Data");
            return;
        }
        self.started = false;
        self.successDate = [NSDate date];
        DDLogInfo(@"fetch app config from server finish");
        NSDictionary *dict = (NSDictionary *) responseObject;
        self.model = [ConfigModel mj_objectWithKeyValues:dict];
        for (id<ConfigCallback> delegate in self.callbackList) {
            [delegate configNotifyChange];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DDLogWarn(@"%@", error);
        self.started = false;
        [self performSelector:@selector(fetch) withObject:nil afterDelay:60];
    }];
}

- (void)show:(UIViewController *)controller {
    if (![self hasNewVersion]) {
        DDLogDebug(@"no new version");
        return;
    }
    if (self.shown) {
        DDLogDebug(@"Alert is already presenting");
        return;
    }
    if (!([_model isUpgradeNormal] || [_model isUpgradeForce])) {
        DDLogDebug(@"Do not prompt for upgrade version");
        return;
    }
    NSString *updateAddress = _model.updateAddress;
    DDLogDebug(@"updateAddress:%@", updateAddress);
    NSBundle *mainBundle = [NSBundle mainBundle];
    DDLogDebug(@"%@", mainBundle.bundlePath);
    NSString *path = [mainBundle pathForResource:@"Frameworks/UpgradePod.framework/UpgradePod" ofType:@"bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:path];
    NSString *upgradeTitle = NSLocalizedStringFromTableInBundle(@"upgrade.title", @"UpgradePod", bundle, nil);
    NSString *actionCancel = NSLocalizedStringFromTableInBundle(@"action.cancel", @"UpgradePod", bundle, nil);
    NSString *actionUpgrade = NSLocalizedStringFromTableInBundle(@"action.upgrade", @"UpgradePod", bundle, nil);
    BOOL upgradeForce = [_model isUpgradeForce];
    UIAlertController *c = [UIAlertController alertControllerWithTitle:upgradeTitle message:_model.updateTip preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:actionUpgrade style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:updateAddress] options:@{} completionHandler:^(BOOL success) {
            DDLogDebug(@"openURL completion %@", success ? @"success" : @"error");
            if (upgradeForce) {
                exit(0);
            }
        }];
        self.shown = false;
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:actionCancel style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (upgradeForce) {
            exit(0);
        }
    }];
    [c addAction:action];
    [c addAction:cancel];
    [controller presentViewController:c animated:YES completion:nil];
    self.shown = true;
}

- (BOOL)hasNewVersion {
    return _model && [_model hasNewVersion:_marketingVersion];
}

@end
