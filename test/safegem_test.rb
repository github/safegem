require 'rubygems'
require 'test/unit'
require 'net/http'
require 'cgi'
require 'fileutils'
require 'open4'

OUTPUT = !!ENV['OUTPUT']
puts "safegem output disabled, set OUTPUT=1 to enable" if ! OUTPUT

def mv(a, b)
  here = File.dirname(__FILE__)
  FileUtils.mv(File.join(here, a), File.join(here, b))
end

def log(x)
  puts x if OUTPUT
end

# ensure git_mock is in place before running any of these tests
mv('git', 'git_mock') rescue nil

class SafeGemTest < Test::Unit::TestCase
  def setup
    here = File.dirname(__FILE__)

    # put the mock git in place
    mv('git_mock', 'git')

    # construct the safegem command
    cmd = "PATH=#{here}:$PATH ruby #{here}/../bin/safegem"
    cmd += " > /dev/null 2>&1" unless OUTPUT
    
    log(cmd)

    # run safegem
    @pid, _, _, _ = Open4::popen4(cmd)

    # wait for server to start
    Timeout::timeout(5) do
      begin
        TCPSocket.open('localhost', 4567) {}
        server_started = true
        log 'good'
      rescue Errno::ECONNREFUSED
        log 'err'
        server_started = false
        sleep 0.1
        retry
      end until server_started
    end
  end

  def teardown
    log "Killing #{@pid}"
    Process.kill("SIGHUP", @pid)
    mv('git', 'git_mock')
    sleep(0.5) # to let sinatra unbind the socket
    log "Teardown complete"
  end

  def test_access_to_untainted_locals
    %w(repo data spec params).each do |v|
      assert_nil_error v
    end
  end

  # def test_timeout
  #   puts "\ntesting 30s timeout"
  #   begin
  #     timeout(32) do
  #       s = req <<-EOS
  #         def forever
  #           loop{}
  #         ensure
  #           forever
  #         end
  #         forever
  #       EOS
  #       assert_equal "ERROR: execution expired", s
  #     end
  #   rescue Timeout::Error
  #     fail "timed out! no good!"
  #   end
  # end

  def test_legit_gemspec_works
    gemspec = <<-EOS
      Gem::Specification.new do |s|
        s.name = "name"
        s.description = 'description'
        s.version = "0.0.9"
        s.summary = ""
        s.authors = ["coderrr"]
        s.files = ['x']
      end
    EOS
    expected_response = <<-EOS
--- !ruby/object:Gem::Specification
name: name
version: !ruby/object:Gem::Version
  version: 0.0.9
platform: ruby
authors:
- coderrr
autorequire:
bindir: bin
cert_chain: []

date: 2008-10-31 00:00:00 +07:00
default_executable:
dependencies: []

description: description
email:
executables: []

extensions: []

extra_rdoc_files: []

files:
- x
has_rdoc: false
homepage:
post_install_message:
rdoc_options: []

require_paths:
- lib
required_ruby_version: !ruby/object:Gem::Requirement
  requirements:
  - - ">="
    - !ruby/object:Gem::Version
      version: "0"
  version:
required_rubygems_version: !ruby/object:Gem::Requirement
  requirements:
  - - ">="
    - !ruby/object:Gem::Version
      version: "0"
  version:
requirements: []

rubyforge_project:
rubygems_version: 1.3.0
signing_key:
specification_version: 2
summary: ""
test_files: []
    EOS
    assert_equal clean_yaml(expected_response), clean_yaml(req(gemspec))
  end

  def test_gemspec_with_glob_works
    system("mkdir globdir && cd globdir && touch a.rb b.rb c.txt")
    gemspec = <<-EOS
      Gem::Specification.new do |s|
        s.name = "name"
        s.description = 'description'
        s.version = "0.0.9"
        s.summary = ""
        s.authors = ["coderrr"]
        s.files = Dir.glob("globdir/**.rb")
        s.test_files = Dir["globdir/**"]
        # make sure array globs work with .glob and make sure glob flags work
        s.executables = Dir.glob(["globdir/*.TXT", "globdir/*.RB"], File::FNM_CASEFOLD)
        # make sure array globs work with [] and make sure we cant access files in parent dirs
        s.extra_rdoc_files = Dir["/etc/*", "globdir"]
      end
    EOS
    expected_response = <<-EOS
--- !ruby/object:Gem::Specification
name: name
version: !ruby/object:Gem::Version
  version: 0.0.9
platform: ruby
authors:
- coderrr
autorequire:
bindir: bin
cert_chain: []


default_executable:
dependencies: []

description: description
email:
executables:
- globdir/c.txt
- globdir/a.rb
- globdir/b.rb
extensions: []

extra_rdoc_files:
- globdir
files:
- globdir/a.rb
- globdir/b.rb
has_rdoc: false
homepage:
post_install_message:
rdoc_options: []

require_paths:
- lib
required_ruby_version: !ruby/object:Gem::Requirement
  requirements:
  - - ">="
    - !ruby/object:Gem::Version
      version: "0"
  version:
required_rubygems_version: !ruby/object:Gem::Requirement
  requirements:
  - - ">="
    - !ruby/object:Gem::Version
      version: "0"
  version:
requirements: []

rubyforge_project:

signing_key:
specification_version: 2
summary: ""
test_files:
- globdir/a.rb
- globdir/b.rb
- globdir/c.txt
    EOS
    assert_equal clean_yaml(expected_response), clean_yaml(req(gemspec))
  ensure
    system("rm -rf globdir")
  end

  def test_tmpdir_is_destroyed
    Dir.mkdir('tmp/safegem_test')
    assert File.exist?('tmp/safegem_test')
    req('')
    assert ! File.exist?('tmp/safegem_test')
  end

  def test_secure_parser_begin
    resp = req <<-EOS
      BEGIN {require 'bogus_file'}
    EOS
    assert resp.include?('Insecure operation')
  end

  def test_secure_parser_end
    resp = req <<-EOS
      END {fail 'secret exit'}
    EOS
    assert !resp.include?('secret exit')
  end

  private

  def clean_yaml(y)
    y.strip.gsub(/ *$/m, '').sub(/^date:.+$/,'').sub(/^rubygems_version:.+$/,'')
  end

  def assert_nil_error(v)
    assert req("#{v}.abc").include?("undefined method `abc' for nil"), "#{v} was not nil"
  end

  def req(data)
    Net::HTTP.start 'localhost', 4567 do |h|
      h.post('/', "data=#{CGI.escape data}&repo=safegem_test").body
    end
  end
end
