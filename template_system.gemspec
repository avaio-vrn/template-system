# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'template_system/version'

Gem::Specification.new do |spec|
  spec.name          = "template_system"
  spec.version       = TemplateSystem::VERSION
  spec.authors       = ["Alexandr S"]
  spec.email         = ["alexandr@avaio-media.ru"]
  spec.summary       = %q{Template system for site's content}
  spec.description   = %q{The template system for placing content on the site. The ability to create new templates for quick and easy addition of information (text and graphics).}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'activesupport', '~>3.2'

  spec.add_dependency "paperclip", '~> 4'
  spec.add_dependency "ckeditor", '4.1.2'
  spec.add_dependency "cancancan", '~> 1'

  spec.add_dependency 'railties', '~>3.2'
end
