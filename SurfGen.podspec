Pod::Spec.new do |s|
  s.name           = 'SurfGen'
  s.version        = '0.0.1'
  s.summary        = 'Command line tool for parsing and generating code for OpenAPI 3.0+ specs'
  s.homepage       = 'https://gitlab.com/surfstudio/ios/tools/SurfGen'
  s.source         = { :git => 'https://gitlab.com/surfstudio/infrastructure/ios-tools/SurfGen.git', :tag => s.version.to_s }
  s.author         = { "Mikhail Monakov" => "mm.monakov@gmail.com" }
  s.source_files   = 'Binary/**/*'
end