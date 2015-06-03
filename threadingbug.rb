#!/usr/bin/env ruby
require "java"
require "sidekiq"

Sidekiq.configure_client do |config|
  config.redis = { :namespace => "threadingbug", :size => 1 }
end

Sidekiq.configure_server do |config|
  config.redis = { :namespace => "threadingbug" }
end

class ThreadingBug
  include Sidekiq::Worker

  def perform
    puts "Number of threads: #{Java::JavaLang::Thread.active_count}"
  end
end

if ENV["RUNNING_IN_SIDEKIQ"] != "true"
  VALID_COMMANDS = ["sidekiq", "sidekiq-threaded", "test"]

  if ARGV.empty? || !VALID_COMMANDS.include?(ARGV.first)
    puts "usage: ./threadingbug.rb <#{VAliD_COMMANDS.join "|"}>"
    exit false
  end

  case ARGV.first
  when "sidekiq"
    exec({ "RUNNING_IN_SIDEKIQ" => "true" }, "bundle", "exec", "sidekiq", "-r", __FILE__, "-c", "4")
  when "sidekiq-threaded"
    exec({ "CELLULOID_TASK_CLASS" => "Threaded", "RUNNING_IN_SIDEKIQ" => "true" }, "bundle", "exec", "sidekiq", "-r", __FILE__, "-c", "4")
  when "test"
    1000.times do
      ThreadingBug.perform_async
    end
  end
end
