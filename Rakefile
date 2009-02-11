require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |s|
    s.name = "github-gem-builder"
    s.summary = %Q{TODO}
    s.email = "tom@mojombo.com"
    s.homepage = "http://github.com/mojombo/github-gem-builder"
    s.description = "TODO"
    s.authors = ["Tom Preston-Werner"]
  end
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end

Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'github-gem-builder'
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
