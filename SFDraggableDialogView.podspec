Pod::Spec.new do |s|
  s.name         = "SFDraggableDialogView"
  s.version      = "1.0.7"
  s.summary      = "Display the beautiful dialog view with realistic physics behavior."

  s.description  = <<-DESC
                   Display the beautiful dialog view with realistic physics behavior (thanks to UIkit Dynamics) with drag to dismiss feature.
                   DESC

  s.homepage     = "https://github.com/kubatru/SFDraggableDialogView"
  s.screenshots  = "https://raw.githubusercontent.com/kubatru/SFDraggableDialogView/master/Screens/preview.png"

  s.license      = { :type => "MIT", :file => "LICENSE.md" }
  s.author    = "Jakub Truhlar"
  s.social_media_url   = "http://kubatruhlar.cz"
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/kubatru/SFDraggableDialogView.git", :tag => "1.0.7" }
  s.source_files  = "SFDraggableDialogView/*"
  s.resource_bundles = {
    'SFDraggableDialogView' => ['Pod/**/*.{png, xib}']
  }
  s.framework  = "UIKit"
  s.requires_arc = true
end
