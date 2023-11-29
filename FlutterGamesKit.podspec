Pod::Spec.new do |s|
  s.name             = 'FlutterGamesKit'
  s.platform         = :ios, '12.0'
  s.version          = '1.0.4'
  s.summary          = 'Flutter 版本游戏SDK'

  s.description      = <<-DESC
  Flutter 游戏 SDK iOS、Android双端
  Flutter插件编写，支持iOS 和 Android，该工程是iOS参考demo
                       DESC

  s.homepage         = 'https://github.com/MF-dosear/FlutterGamesKit'

  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Paul' => 'dosear@qq.com' }
  s.source           = { :git => 'https://github.com/MF-dosear/FlutterGamesKit.git', :tag => s.version.to_s }
  
  s.requires_arc = true
  
  valid_archs = ['arm64',]

  s.pod_target_xcconfig = {
    'VALID_ARCHS[sdk=iphonesimulator*]' => ''
  }

  s.ios.deployment_target = '12.0'

  s.source_files = ['FlutterGamesKit/Classes/**/*']
  
  s.vendored_frameworks = ['FlutterGamesKit/Frameworks/*.xcframework']
  
  s.dependency 'AFNetworking','~> 4.0.1'
  s.dependency 'SVProgressHUD','~> 2.3.1'
  
end
