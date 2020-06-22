platform :ios, '11.0'

inhibit_all_warnings!

target 'InstagramReplica' do
  pod 'Firebase/Core', :inhibit_warnings => true
  pod 'Firebase/Database', :inhibit_warnings => true
  pod 'Firebase/Auth', :inhibit_warnings => true
  pod 'Firebase/Storage', :inhibit_warnings => true
  
  use_frameworks!
  pod 'GetStreamActivityFeed'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '4.2'
    end
  end
end