source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!
inhibit_all_warnings!

## Проверено на версии cocoapods-1.1.1

def default_pods
    pod 'AFNetworking', '~> 3.2'
end

target 'ImagesFeedTest' do
    default_pods
end

post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
        config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
    end
end