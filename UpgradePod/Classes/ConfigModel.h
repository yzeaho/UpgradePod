#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ConfigModel : NSObject

/**
 * 版本号
 */
@property (nonatomic, copy) NSString *version;

/**
 * 更新状态
 */
@property (nonatomic, assign) int updateState;

/**
 * 弹窗提示信息
 */
@property (nonatomic, copy) NSString *updateTip;

/**
 * 下载地址
 */
@property (nonatomic, copy) NSString *updateAddress;

/**
 * 版本详情
 */
@property (nonatomic, copy) NSString *updateDetails;

/**
 * 发布时间
 */
@property (nonatomic, copy) NSString *publishTime;

/**
 * 文件大小
 */
@property (nonatomic, copy) NSString *appSize;

/**
 * 有新版本？
 */
- (BOOL)hasNewVersion:(NSString *)marketingVersion;

/**
 * 是建议升级？
 */
- (BOOL)isUpgradeNormal;

/**
 * 是强制升级？
 */
- (BOOL)isUpgradeForce;

@end

NS_ASSUME_NONNULL_END
