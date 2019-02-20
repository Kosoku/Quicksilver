#
# Be sure to run `pod lib lint ${POD_NAME}.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Quicksilver'
  s.version          = '2.0.2'
  s.summary          = 'Quicksilver is an iOS/macOS/tvOS/watchOS framework that extends the collection classes and makes them easier to work with.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Quicksilver is an iOS/macOS/tvOS/watchOS framework that extends the collection classes (`NSArray`,`NSSet`,`NSOrderedSet`,`NSDictionary`, and `NSString`) and makes them easier to work with. The added methods are modeled after the related list functions (`map`,`filter`,`reduce`, etc.) in Haskell.
                       DESC

  s.homepage         = 'https://github.com/Kosoku/Quicksilver'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'Apache 2.0', :file => 'LICENSE.txt' }
  s.author           = { 'William Towe' => 'willbur1984@gmail.com' }
  s.source           = { :git => 'https://github.com/Kosoku/Quicksilver.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'
  s.osx.deployment_target = '10.12'
  s.tvos.deployment_target = '10.0'
  s.watchos.deployment_target = '3.0'
  
  s.requires_arc = true

  s.source_files = 'Quicksilver/**/*.{h,m}'
  s.exclude_files = 'Quicksilver/Quicksilver-Info.h'
  
  # s.resource_bundles = {
  #   '${POD_NAME}' => ['${POD_NAME}/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'Foundation', 'CoreGraphics'
  # s.dependency 'AFNetworking', '~> 2.3'
end
