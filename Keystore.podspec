Pod::Spec.new do |s|
  s.name             = 'Keystore'
  s.version          = '0.1.0'
  s.summary          = 'Ethereum keystore library'

  s.description      = <<-DESC
A library which generates Ethereum keystore files from private keys and extracts private keys from keystore files.
                       DESC

  s.homepage         = 'https://github.com/Boilertalk/Keystore.swift'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Koray Koska' => 'koray@koska.at' }
  s.source           = { :git => 'https://github.com/Boilertalk/Keystore.swift.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.10'
  s.tvos.deployment_target = '9.0'
  s.watchos.deployment_target = '2.0'

  s.source_files = 'Keystore/Classes/**/*'

  s.dependency 'CryptoSwift', '~> 0.8'
  s.dependency 'secp256k1.swift', '~> 0.1'

  # s.resource_bundles = {
  #   'Keystore' => ['Keystore/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
