#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ConfigCallback

- (void)configNotifyChange;

@end

@interface ConfigService : NSObject

@property (nonatomic, copy) NSString *currentVersion;
@property (nonatomic, copy) NSString *marketingVersion;

+ (instancetype)sharedInstance;

- (void)config:(NSString *)url;

- (void)addCallback:(id<ConfigCallback>)callback;

- (void)removeCallback:(id<ConfigCallback>)callback;

- (void)show:(UIViewController *)controller;

@end

NS_ASSUME_NONNULL_END
