#
#  Be sure to run `pod spec lint VTMagic.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
    s.name       = 'VTMagic'
    s.version    = '1.0.0'
    s.license    = { :type => 'MIT' }
    s.homepage   = 'https://github.com/tianzhuo112/VTMagic'
    s.authors    = { 'tianzhuo' => 'tianzhuo112@163.com' }
    s.summary    = 'Page controller manager for iOS.'
    s.source     = { :git => 'https://github.com/tianzhuo112/VTMagic.git', :tag => s.version.to_s }
    s.source_files = 'VTMagic/**/*.{h,m}'

    s.platform   = :ios, "6.0"
    s.requires_arc = true
    s.frameworks = 'UIKit'
end
