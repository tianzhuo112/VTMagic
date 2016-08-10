#
#  Be sure to run `pod spec lint VTMagic.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
    s.name       = 'VTMagic'
    s.version    = '1.2.4'
    s.license    = { :type => 'MIT' }
    s.homepage   = 'https://github.com/tianzhuo112/VTMagic'
    s.authors    = { 'tianzhuo' => 'tianzhuo112@163.com' }
    s.summary    = 'A page container for iOS.'
    s.description = <<-DESC
                        VTMagic is a page container library for iOS, it can manage many different pages. VTMagicView contains a menu bar and a content view, all pages are add to content view.
                     DESC
    s.source     = { :git => 'https://github.com/tianzhuo112/VTMagic.git', :tag => s.version.to_s }

    s.public_header_files = 'VTMagic/VTMagic.h'
    s.source_files = 'VTMagic/VTMagic.h'

    s.platform   = :ios, "6.0"
    s.requires_arc = true
    s.frameworks = 'UIKit'

    s.subspec 'Core' do |ss|
        ss.ios.deployment_target = '6.0'
        ss.exclude_files = 'VTMagic/VTMagic.h'
        ss.source_files = 'VTMagic/**/*.{h,m}'
    end
end
