require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |s|
    s.name = "safegem"
    s.summary = %Q{GitHub's safe gem eval web service}
    s.email = "tom@mojombo.com"
    s.homepage = "http://github.com/github/safegem"
    s.description = "GitHub's safe gem eval web service"
    s.authors = ["PJ Hyett", "Tom Preston-Werner"]
    s.add_dependency('json', '>= 1.1.3')
    s.add_dependency('sinatra', '>= 0.9.1.1')
    s.add_dependency('thin', '>= 1.0.0')
  end
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end

Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'safegem'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |t|
    t.libs << 'test'
    t.test_files = FileList['test/**/*_test.rb']
    t.verbose = true
  end
rescue LoadError
end

task :test do
  # the test files must be run in isolation because they mess with security
  Dir['test/**/*_test.rb'].each do |file|
    sh "ruby #{file}"
  end
end

task :default => :test
