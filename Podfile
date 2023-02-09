source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '11.0'
use_modular_headers!

flutter_application_path = '../module'
load File.join(flutter_application_path, '.ios', 'Flutter', 'podhelper.rb')

target 'unit' do
  install_all_flutter_pods(flutter_application_path)
  
  pod 'SVProgressHUD'
  pod 'AFNetworking'
  
end

post_install do |installer|
  flutter_post_install(installer) if defined?(flutter_post_install)
end
