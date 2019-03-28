#
# Be sure to run `pod lib lint Leaflet.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "Leaflet"
  s.version          = "0.3"
  s.summary          = "A simple event notify by Swift"

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!  
  s.description      = "Simple event notify on UIViewController by Swift."

  s.homepage         = "https://github.com/GE-N/Leaflet"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Jerapong Nampetch" => "jerapong@gomeeki.com" }
  s.source           = { :git => "https://github.com/GE-N/Leaflet.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/onoaonoa'

  s.platform     = :ios, '9.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  # s.resource_bundles = {
  #   'Leaflet' => ['Pod/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'TZStackView', '1.3.0'
  s.dependency 'SnapKit', '~> 4.2'
end
