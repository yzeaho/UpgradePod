#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ConfigModel : NSObject

@property (nonatomic, copy) NSString *version;           //版本号
@property (nonatomic, assign) int updateState;           //更新状态
@property (nonatomic, copy) NSString *updateTip;         //弹窗提示信息
@property (nonatomic, copy) NSString *updateAddress;     //下载地址
@property (nonatomic, copy) NSString *updateDetails;     //版本详情
@property (nonatomic, copy) NSString *publishTime;       //发布时间
@property (nonatomic, copy) NSString *appSize;           //文件大小

- (BOOL)hasNewVersion:(NSString *)marketingVersion;

@end

NS_ASSUME_NONNULL_END
