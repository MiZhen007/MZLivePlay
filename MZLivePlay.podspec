Pod::Spec.new do |s|
s.name         = 'MZLivePlay'
s.version      = '1.0.0'
s.summary      = 'excellent, classic live video player and stream pusher, base on Tencent live SDK and IM SDK, contains chat room'
s.homepage     = 'https://github.com/MiZhen007/MZLivePlay'
s.license      = { :type => 'MIT', :file => 'LICENSE' }
s.author       = { "mizhen007" => "mee1127tech@163.com" }
s.source       = { :git => 'https://github.com/MiZhen007/MZLivePlay.git', :tag => 'v'+s.version.to_s }
s.platforms    = { :ios => "9.0", :osx => "" }
s.requires_arc = true

s.ios.source_files         = 'MZLivePlay/*.{h,m}'

s.frameworks      = "UIKit","libz.tbd","libstdc++.tbd","libresolv.tbd","Accelerate.framework","CoreTelephony.framework","SystemConfiguration.framework","libstdc++.6.dylib","libc++.dylib","libz.dylib","libsqlite3.dylib"

end
