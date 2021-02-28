#
# Be sure to run `pod lib lint HHComponents.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'HHComponents'
  s.version          = '0.1.0'
  s.summary          = 'A short description of HHComponents.'


  s.description      = <<-DESC
            功能组件.
                       DESC

  s.homepage         = 'https://github.com/huahong1124/HHComponents'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'huahong1124' => '2330669775@qq.com' }
  s.source           = { :git => 'https://github.com/huahong1124/HHComponents.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'HHComponents/Classes/*.{h,m,swift}'
  s.public_header_files = 'HHComponents/Classes/*.{h,m,swift}'
  
   #--------------------subspec-----------------------------------------------#
      
       s.subspec 'ProgressHud' do |ss|
       ss.source_files = 'HHComponents/Classes/ProgressHud/*.{h,m,swift}'
       ss.resources = 'HHComponents/Classes/ProgressHud/*.bundle'
       ss.dependency 'MBProgressHUD'
       ss.dependency 'SVProgressHUD'
       end
         
       s.subspec 'Cookie' do |ss|
       ss.source_files = 'HHComponents/Classes/Cookie/*.{h,m,swift}'
       end
      
       s.subspec 'CleanCache' do |ss|
       ss.source_files = 'HHComponents/Classes/CleanCache/*.{h,m,swift}'
       end
       
       s.subspec 'Media' do |ss|
       ss.source_files = 'HHComponents/Classes/Media/*.{h,m,swift}'
#       s.dependency 'BaseModule'
       
        end
        
       s.subspec 'PickerView' do |ss|
       ss.source_files = 'HHComponents/Classes/PickerView/*.{h,m,swift}'
       end
       
       s.subspec 'CameraButton' do |ss|
       ss.source_files = 'HHComponents/Classes/CameraButton/*.{h,m,swift}'
       end
       
       
       s.subspec 'Contacts' do |ss|
       ss.source_files = 'HHComponents/Classes/Contacts/*.{h,m,swift}'
        end
              
       s.subspec 'DecimalNumber' do |ss|
       ss.source_files = 'HHComponents/Classes/DecimalNumber/*.{h,m,swift}'
       end
             
       s.subspec 'QRCode' do |ss|
       ss.source_files = 'HHComponents/Classes/QRCode/*.{h,m,swift}'
       end
       
       s.subspec 'WaterFallLayout' do |ss|
       ss.source_files = 'HHComponents/Classes/WaterFallLayout/*.{h,m,swift}'
       end
       
       s.subspec 'Capture' do |ss|
       ss.source_files = 'HHComponents/Classes/Capture/*.{h,m,swift}'
       end
             
       s.subspec 'Timer' do |ss|
       ss.source_files = 'HHComponents/Classes/Timer/*.{h,m,swift}'
       end
       
       s.subspec 'RSA' do |ss|
       ss.source_files = 'HHComponents/Classes/RSA/*.{h,m,swift}'
       end
       
       s.subspec 'Authorization' do |ss|
       ss.source_files = 'HHComponents/Classes/Authorization/*.{h,m,swift}'
       end
       
       s.subspec 'UUID' do |ss|
       ss.source_files = 'HHComponents/Classes/UUID/*.{h,m,swift}'
       end
       
       s.subspec 'PhotoBrowser' do |ss|
       ss.source_files = 'HHComponents/Classes/PhotoBrowser/*.{h,m,swift}'
       ss.dependency 'SDWebImage', '~> 4.2.3'
       end
       
       s.subspec 'Location' do |ss|
       ss.source_files = 'HHComponents/Classes/Location/*.{h,m,swift}'
       end
       
       s.subspec 'Album' do |ss|
       ss.source_files = 'HHComponents/Classes/Album/*.{h,m,swift}'
       ss.resources = "HHComponents/Classes/Album/*.{bundle,xcassets,xib,storyboard}"
       end
       
      s.subspec 'AudioRecorder' do |ss|
      ss.source_files = 'HHComponents/Classes/AudioRecorder/*.{h,m,swift}'
      ss.dependency 'mp3lame-for-ios', '~> 0.1.1'
      end
      
      s.subspec 'HHLockView' do |ss|
      ss.source_files = 'HHComponents/Classes/HHLockView/*.{h,m,swift}'
      ss.resource_bundles = {
        'HHLockView' => ['HHComponents/Classes/HHLockView/Assets/*.png']
      }
      end
      
      
      s.subspec 'AlertView' do |ss|
      ss.source_files = 'HHComponents/Classes/AlertView/*.{h,m,swift}'
      ss.dependency 'UITextView+Placeholder'
      ss.dependency 'Masonry'
      end
      
    #--------------------subspec-----------------------------------------------#
  
  
  # s.resource_bundles = {
  #   'HHComponents' => ['HHComponents/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  s.dependency 'HHBaseKit'
  
end
