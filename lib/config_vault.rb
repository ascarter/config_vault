require "config_vault/apm"
require "config_vault/archive"
require "config_vault/downloader"
require "config_vault/git"
require "config_vault/go"
require "config_vault/homebrew"
require "config_vault/macos"
require "config_vault/nodejs"
require "config_vault/pip"
require "config_vault/verification"
require "config_vault/version"

require 'io/console'

module ConfigVault
  class Error < StandardError; end
  
  module_function

  # Platform checks

  def macOS?
    RUBY_PLATFORM =~ /darwin/
  end

  def linux?
    RUBY_PLATFORM =~ /linux/
  end

  def windows?
    RUBY_PLATFORM =~ /windows/
  end

  def require_macOS
    raise 'macOS required' unless macOS?
  end

  def require_linux
    raise 'Linux required' unless linux?
  end

  def require_windows
    raise 'Windows required' unless windows?
  end

  def request_input(message, default = nil)
    prompt "Enter #{message}", default
  end

  def prompt(message, default = nil)
    print "#{message}#{" [#{default}]" unless default.nil?}: "
    $stdin = IO.new(2) if $stdin.nil?
    response = $stdin.gets.chomp
    response.empty? ? default : response
  end

  def prompt_to_continue
    puts 'Press any key to continue'
    $stdin = IO.new(2) if $stdin.nil?
    $stdin.getch
    puts "\n"
  end

  # user

  def home_dir
    File.expand_path(ENV['HOME'])
  end

  def current_user
    Etc.getlogin
  end

  def user_info(user = Etc.getlogin)
    Etc.getpwnam(user)
  end

  # sudo

  def sudo(cmd)
    puts "(sudo)"
    system "sudo sh -c '#{cmd}'"
  end
end
