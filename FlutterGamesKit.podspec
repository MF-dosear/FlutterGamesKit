Pod::Spec.new do |s|
  s.name             = 'FlutterGamesKit'
  s.platform         = :ios, '12.0'
  s.version          = '1.0.1'
  s.summary          = 'Flutter 版本游戏SDK'

  s.description      = <<-DESC
TODO: Add long description of the pod here.
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

  s.source_files = 'FlutterGamesKit/Classes/**/*'
  
  s.vendored_frameworks = 'FlutterGamesKit/Frameworks/*.xcframework'
  
  s.dependency 'AFNetworking','~> 4.0.1'
  
end
