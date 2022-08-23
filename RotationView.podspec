#
# Be sure to run `pod lib lint RotationView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'RotationView'
  s.version          = '0.1.0'
  s.summary          = 'RotationView inherits from UIView and provides rotation functionality.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  RotationView inherits from UIView. A rotation view has a small view on each corner. 
  Users can manipulate the corner views to rotate or scale the rotation view.
                       DESC

  s.homepage         = 'https://github.com/Aoi SHIRATORI/RotationView'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Aoi SHIRATORI' => 'aoy.shiratori@gmail.com' }
  s.source           = { :git => 'https://github.com/Aoi SHIRATORI/RotationView.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

  s.source_files = 'RotationView/Classes/**/*'
  
  # s.resource_bundles = {
  #   'RotationView' => ['RotationView/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
