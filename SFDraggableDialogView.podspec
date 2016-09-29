Pod::Spec.new do |s|
  s.name         = "SFDraggableDialogView"
  s.version      = "1.1.5"
  s.summary      = "Display the beautiful dialog view with realistic physics behavior."

  s.description  = <<-DESC
                   Display the beautiful dialog view with realistic physics behavior (thanks to UIkit Dynamics) with drag to dismiss feature.
                   DESC

  s.homepage     = "https://github.com/kubatruhlar/SFDraggableDialogView"
  s.screenshots  = "https://raw.githubusercontent.com/kubatruhlar/SFDraggableDialogView/master/Screens/preview.png"

  s.license      = { :type => "MIT", :file => "LICENSE.md" }
  s.author    = "Jakub Truhlar"
  s.social_media_url   = "http://kubatruhlar.cz"
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/kubatruhlar/SFDraggableDialogView.git", :tag => "1.1.5" }
  s.source_files  = "SFDraggableDialogView/*.{h,m}"
  s.resources = ["SFDraggableDialogView/**/*.{png,xib}"]
  s.framework  = "UIKit"
  s.requires_arc = true
end
