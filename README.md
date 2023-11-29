# FlutterGamesKit

[![CI Status](https://img.shields.io/travis/dosear@qq.com/FlutterGamesKit.svg?style=flat)](https://travis-ci.org/dosear@qq.com/FlutterGamesKit)
[![Version](https://img.shields.io/cocoapods/v/FlutterGamesKit.svg?style=flat)](https://cocoapods.org/pods/FlutterGamesKit)
[![License](https://img.shields.io/cocoapods/l/FlutterGamesKit.svg?style=flat)](https://cocoapods.org/pods/FlutterGamesKit)
[![Platform](https://img.shields.io/cocoapods/p/FlutterGamesKit.svg?style=flat)](https://cocoapods.org/pods/FlutterGamesKit)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

FlutterGamesKit is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'FlutterGamesKit'
```

## Author

罗小黑不吹, dosear@qq.com, http://www.dosear.cn

## Flutter 游戏 SDK iOS、Android双端

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


## License

FlutterGamesKit is available under the MIT license. See the LICENSE file for more info.
