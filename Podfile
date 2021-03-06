# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

def install_pods
  pod 'PKHUD'
  pod 'SwiftyJSON'
  pod 'Moya/RxSwift', '~> 14.0'
  pod 'RxSwift'
  pod 'RxDataSources'
  pod 'RxCocoa'
  pod 'RealmSwift'
  pod 'Instantiate'
  pod 'InstantiateStandard'
  pod 'Alamofire'
  pod 'IBAnimatable'
  pod 'Direction'
  # google map SDK for iOS
  pod 'GoogleMaps'
  pod 'GooglePlaces'
  pod 'SDWebImage', '~> 4.3.3'

end

def install_test_pods
  pod 'Quick'
  pod 'Nimble'
  pod 'RxTest'
end

target 'GourmentSearch' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  install_pods
  # Pods for GourmentSearch

  target 'GourmentSearchTests' do
    inherit! :search_paths
    install_test_pods
    # Pods for testing
  end

  target 'GourmentSearchUITests' do
    # Pods for testing
    install_test_pods
  end

end
