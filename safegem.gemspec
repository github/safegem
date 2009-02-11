# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{safegem}
  s.version = "0.1.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["PJ Hyett", "Tom Preston-Werner"]
  s.date = %q{2009-02-10}
  s.default_executable = %q{safegem}
  s.description = %q{GitHub's safe gem eval web service}
  s.email = %q{tom@mojombo.com}
  s.executables = ["safegem"]
  s.files = ["VERSION.yml", "bin/safegem", "lib/safegem", "lib/safegem/lazy_dir.rb", "lib/safegem/security.rb", "lib/safegem.rb", "test/git_mock", "test/lazy_dir_test.rb", "test/safegem_test.rb", "test/security_test.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/github/safegem}
  s.rdoc_options = ["--inline-source", "--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.0}
  s.summary = %q{GitHub's safe gem eval web service}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
