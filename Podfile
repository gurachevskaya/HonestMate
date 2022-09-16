platform :ios, '16.0'
use_frameworks!

def firebase_pods
  pod 'Firebase/Analytics'
  pod 'Firebase/Database'
  pod 'Firebase/Auth'
  pod 'Firebase/Storage'
  pod 'Firebase/RemoteConfig'
end

def helpers_pods
  pod 'R.swift'
  pod 'Resolver'
end

target 'HonestMate' do
  helpers_pods
  firebase_pods

  target 'HonestMateTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'HonestMateUITests' do
    # Pods for testing
  end

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '16.0'
    end
  end
end

