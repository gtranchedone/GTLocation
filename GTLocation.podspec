Pod::Spec.new do |s|
  s.name         = "GTLocation"
  s.version      = "0.0.4"
  s.summary      = "An extension to Core Location that adds categories and classes to easier working with locations. Supports the Google Maps SDK."
  s.description  = <<-DESC
                	An extension to Core Location that adds categories and classes to easier working with locations. It also adds classes to interface with the Google Maps and Google Places APIs that aren't exposed in the Google Maps SDK.
                   DESC
  s.homepage     = "http://cocoabeans.me/projects/open-source"
  s.license      = 'MIT'
  s.author       = { "Gianluca Tranchedone" => "gianluca@cocoabeans.me" }
  s.source       = { :git => "https://github.com/gtranchedone/GTLocation.git", :tag => s.version.to_s }

  s.ios.deployment_target = '7.0'
  s.osx.deployment_target = '10.9'
  s.requires_arc = true

  s.source_files = 'Classes/**/*'
  s.ios.exclude_files = 'Classes/osx'
  s.osx.exclude_files = 'Classes/ios'
  s.public_header_files = 'Classes/**/*.h'
  
  s.frameworks = 'CoreLocation'
  s.dependency 'GTFoundation', '~> 0.0.9'
end
