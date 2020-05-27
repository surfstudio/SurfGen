Pod::Spec.new do |s|
  s.name           = 'SurfGen'
  s.version        = '0.1.0'
  s.summary        = 'Command line tool for parsing and generating code for OpenAPI 3.0+ specs'
  s.homepage       = 'https://github.com/JohnReeze/SurfGen'
  s.source         = { :git => 'https://github.com/JohnReeze/SurfGen.git', :tag => s.version.to_s }
  s.author         = { "Mikhail Monakov" => "mm.monakov@gmail.com" }
  s.source_files   = 'Binary/**/*' 
  s.license        = { :type => "MIT", :file => "LICENSE" }
end