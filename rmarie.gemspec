lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)
 
require 'rmarie/version'
 
Gem::Specification.new do |s|
  s.name        = "rMARIE"
  s.version     = Rmarie::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Matthew Godshall"]
  s.email       = ["lifeinhex@gmail.com"]
  s.homepage    = "http://github.com/mgodshall/rMARIE"
  s.summary     = "A simple virtual machine and assembler"
  s.description = "rMARIE provides a simple virtual machine and assembler, which you can write simple or not so simple programs for (maybe)." 
 
  s.required_rubygems_version = ">= 1.8.0"

  s.add_dependency('racc', '1.4.6')
  s.add_dependency('rexical', '1.0.5')
 
  s.files        = Dir.glob("{bin,lib,examples}/**/*") + %w(LICENSE README.md)
  s.executables  = ['rmarie-asm', 'rmarie-vm']
  s.require_path = 'lib'
end
