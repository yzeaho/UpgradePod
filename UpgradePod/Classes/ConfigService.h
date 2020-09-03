#import <Foundation/Foundation.h>
#import "ConfigModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ConfigCallback

- (void)configNotifyChange;

@end

@interface ConfigService : NSObject

/*!
 * @brief App内部版本号，开发使用的版本号
 */
@property (nonatomic, readonly, copy) NSString *currentVersion;

/*!
 * @brief App Store的版本号，对外版本号
 */
@property (nonatomic, readonly, copy) NSString *marketingVersion;

/*!
 * @brief 单例对象
*/
+ (instancetype)sharedInstance;

/*!
 * @brief 配置文件下载地址和启用标识
 */
- (void)setupWithUrl:(NSString *)url enable:(BOOL)enable;

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

/*!
 * @brief 是否有版本更新
 */
- (BOOL)hasNewVersion;

/*!
 * @brief 版本信息
 */
- (ConfigModel *)newModel;

@end

NS_ASSUME_NONNULL_END
