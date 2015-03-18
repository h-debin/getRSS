#!/usr/bin/env ruby

require "yaml"

module EnvironmentChecker
  def is_rbspider_on?
    running_flag_file = File.expand_path('../../.running', __FILE__)
    if File.exist?(running_flag_file)
      true
    else
      false
    end
  end

  def is_monitor_on?
    `tmux ls`.include?("rbspider")
  end

  def is_tmux_on?
    if `pgrep -u #{ENV['USER']} tmux`.chomp != ""
      true
    else
      false
    end
  end

  def prepare_dir
    dir_root = File.expand_path('')
    cache_dir = File.join(dir_root, "cache")
    config_dir = File.join(dir_root, "config")
    system("mkdir -p #{cache_dir}") 
    system("mkdir -p #{config_dir}")
    if !File.directory?(cache_dir) 
      raise "Exception: cannot init cache directory"
    end

    if !File.directory?(config_dir)
      raise "Exception: cannot init configure directory"
    end
  end

  def clean_pending_jobs
    cache_root = File.expand_path('./cache', __FILE__)
    failure_task_queue = File.join(cache_root, 'failure_task.queue')
    pending_task_queue = File.join(cache_root, 'pending_task.queue')
    success_task_queue = File.join(cache_root, 'success_task.queue')
    system("rm -f #{failure_task_queue}") if File.exist?(failure_task_queue)
    system("rm -f #{pending_task_queue}") if File.exist?(pending_task_queue)
    system("rm -f #{success_task_queue}") if File.exist?(success_task_queue)
    raise "Exception: remove the failure task cache met failure" if File.exist?(failure_task_queue)
    raise "Exception: remove the pending task cache met failure" if File.exist?(pending_task_queue)
    raise "Exception: remove the success task cache met failure" if File.exist?(success_task_queue)
  end

  def generate_config(urls)
    config = {
      "name" => "rbspider",
      "windows" => [
        "name" => "rbspider",
        "root" => "./",
        "layout" => "even-horizontal",
        "panes" => [
          "ruby bin/spider.rb #{urls}",
          "sleep 1; ruby bin/monitor_task_failure_queue.rb",
          "sleep 1; ruby bin/monitor_task_pending_queue.rb",
          "sleep 1; ruby bin/monitor_task_done_queue.rb",
        ]
      ]
    }

    File.open("./config/rbspider.yml", "w") do |file|
      file.puts config.to_yaml 
    end
  end
end

module Rbspider
  include EnvironmentChecker

  def self.run
    if !is_tmux_on?
      raise "Exception: no tmux running now, please make your tmux is on"
    end

    if is_rbspider_on?
      raise "Exception: rbspider is running already"
    end

    # ++
    # open fuor tmux panes
    # pane 1: run the spider and show some log
    # pane 2: monitor the failure task
    # pane 3: monitor the pending task in the queue
    # pane 4: monitor the success task in the queue
    # ++
    begin
      system "teamocil --here --layout ./config/rbspider.yml"
    rescue Exception => e
      raise "Exception: cannot open monitor since #{e.to_s}"  
    end
  end
end

require 'optparse'

options = {}
option_parser = OptionParser.new do |opts|
  opts.banner = 'rbspider, a website crawler in ruby with a nice monitor on terminal'

  options[:switch] = true
  opts.on('-s site1, site2', '--sites site1, site2', Array, 'URLs of those site to crawl') do |value|
    options[:sites] =  value
  end

  opts.on('-c', '--clean', 'clean the old pending jobs in queue, kickoff a new start') do |value|
    options[:clean] = value
  end
end.parse!

include Rbspider
$VERBOSE = nil

if options[:clean]
  clean_pending_jobs    
end

if options[:sites]
  # ++
  # prepare some neccessary directory
  # ++
  prepare_dir

  # ++
  # generate the configure according given URLs
  # ++
  urls = options[:sites].join(" ")
  generate_config(urls)

  # ++
  # Ok, everything works well, hit on our spider
  # ++
  Rbspider::run
else
 puts `#{$0} -h`
end
  
