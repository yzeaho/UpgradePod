#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ConfigCallback

- (void)configNotifyChange;

@end

@interface ConfigService : NSObject

/*!
 * @brief App内部版本号
 */
@property (nonatomic, copy) NSString *currentVersion;

/*!
 * @brief App Store的版本号
 */
@property (nonatomic, copy) NSString *marketingVersion;

/*!
 * @brief 单例对象
*/
+ (instancetype)sharedInstance;

/*!
 * @brief 配置文件下载地址和启用标识
 */
- (void)config:(NSString *)url enable:(BOOL)enable;

/**
 * 添加监听回调
 */
- (void)addCallback:(id<ConfigCallback>)callback;

/**
 * 移除监听回调
 */
- (void)removeCallback:(id<ConfigCallback>)callback;

/*!
 * @brief 显示版本更新对话框
*/
- (void)show:(UIViewController *)controller;

@end

NS_ASSUME_NONNULL_END
