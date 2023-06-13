# Flutter 游戏 SDK iOS、Android双端

Flutter插件编写，支持iOS 和 Android，该工程是iOS参考demo

主要功能：

```swift

/// AppDelegate方法
+ (void)sdkApplication:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary<UIApplicationLaunchOptionsKey, id> *)launchOptions;

/// 初始化
+ (void)sdkInitWithParams:(NSDictionary *)params result:(Result)result;

/// 登录
+ (void)sdkLoginWithAuto:(BOOL)flag result:(Result)result;

/// 上传角色
+ (void)sdkSubmitRoleWithParams:(NSDictionary *)params result:(Result)result;

/// 支付
+ (void)sdkPsyWithParams:(NSDictionary *)params result:(Result)result;

/// 登出
+ (void)sdkLogoutWithResult:(Result)result;

/// 分享
+ (void)sdkShareWithTitle:(NSString *)title image:(NSString *)image url:(NSString *)url  result:(Result)result;

/// 打开链接
+ (void)sdkOpenUrlWithUrl:(NSString *)url;

/// 绑定手机号
+ (void)sdkBindPhone;

/// 检查网络
+ (void)sdkCheckNetBlock:(AFNetBlock)block;

```
