Pod::Spec.new do |s|

  s.name               = "Parrot"
  s.version            = "0.0.6"
  s.summary            = "Parrot is a (very) small Swift framework that helps with advertising an iOS device as an iBeacon as well as monitoring/ranging for iBeacons."
  s.description        = <<-DESC
                          Parrot is (very) small Swift framework that helps with iBeacon related functionality on iOS. BeaconAdvertiser advertises an iOS device as an iBeacon, and BeaconRanger monitors/ranges for iBeacons.
                         DESC

  s.homepage           = "https://github.com/carrot-ar/parrot"

  s.license            = "MIT"
  s.author             = "gonzalonunez"
  s.social_media_url   = "http://twitter.com/gonzalonunez"

  s.platform           = :ios, '11.0'
  s.source             = { :git => 'https://github.com/carrot-ar/parrot.git', :tag => s.version.to_s }

  s.source_files       = "Parrot/*.swift"

end
