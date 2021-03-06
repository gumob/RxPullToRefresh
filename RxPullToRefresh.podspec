Pod::Spec.new do |s|

    s.name              = "RxPullToRefresh"
    s.version           = "1.0.1"
    s.summary           = "A Swift library allows you to create a flexibly customizable pull-to-refresh view supporting RxSwift."
    s.homepage          = "https://github.com/gumob/RxPullToRefresh"
    s.documentation_url = "https://gumob.github.io/RxPullToRefresh"
    s.license           = { :type => "MIT", :file => "LICENSE" }
    s.author            = { "gumob" => "hello@gumob.com" }

    s.module_name               = "RxPullToRefresh"
    s.source                    = { :git => "https://github.com/gumob/RxPullToRefresh.git", :tag => "#{s.version}", :submodules => true }
    s.source_files              = ["Sources/*.{swift}"]
    s.requires_arc              = true

    s.swift_version             = "5.0"

    s.ios.deployment_target     = "10.0"
    s.ios.framework             = "Foundation", "UIKit", "CoreGraphics"

    s.dependency 'RxSwift', '~> 5.0'
    s.dependency 'RxCocoa', '~> 5.0'

end
