# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{safegem}
  s.version = "0.2.10"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["PJ Hyett", "Tom Preston-Werner"]
  s.date = %q{2009-04-08}
  s.default_executable = %q{safegem}
  s.description = %q{GitHub's safe gem eval web service}
  s.email = %q{tom@mojombo.com}
  s.executables = ["safegem"]
  s.extra_rdoc_files = [
    "README"
  ]
  s.files = [
    "Rakefile",
    "VERSION.yml",
    "bin/safegem",
    "lib/safegem.rb",
    "lib/safegem/exception.rb",
    "lib/safegem/lazy_dir.rb",
    "lib/safegem/security.rb",
    "test/git_mock",
    "test/lazy_dir_test.rb",
    "test/safegem_test.rb",
    "test/security_test.rb"
  ]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/github/safegem}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.0}
  s.summary = %q{GitHub's safe gem eval web service}
  s.test_files = [
    "test/lazy_dir_test.rb",
    "test/safegem_test.rb",
    "test/security_test.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<json>, [">= 1.1.3"])
      s.add_runtime_dependency(%q<sinatra>, [">= 0.9.1.1"])
      s.add_runtime_dependency(%q<thin>, [">= 1.0.0"])
    else
      s.add_dependency(%q<json>, [">= 1.1.3"])
      s.add_dependency(%q<sinatra>, [">= 0.9.1.1"])
      s.add_dependency(%q<thin>, [">= 1.0.0"])
    end
  else
    s.add_dependency(%q<json>, [">= 1.1.3"])
    s.add_dependency(%q<sinatra>, [">= 0.9.1.1"])
    s.add_dependency(%q<thin>, [">= 1.0.0"])
  end
end
