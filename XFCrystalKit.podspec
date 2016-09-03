Pod::Spec.new do |s|
s.name = 'XFCrystalKit'
s.version = '1.0.0'
s.license = 'MIT'
s.summary = 'Quartz / UIKit drawing tool for IOS.'
s.homepage = 'https://github.com/yizzuide/XFCrystalKit'
s.authors = { 'yizzuide' => 'fu837014586@163.com' }
s.source = { :git => 'https://github.com/yizzuide/XFCrystalKit.git', :tag => s.version.to_s }
s.requires_arc = true
s.ios.deployment_target = '6.0'
s.source_files = 'XFCrystalKit/**/*.{h,m}'
end