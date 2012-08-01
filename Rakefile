#!/usr/bin/env rake
require "bundler/gem_tasks"

namespace :build do
  task :parser do
    system "racc lib/xss.y -o lib/xss/generated_parser.rb -t"
  end
end

task :spec do
  system "rspec"
end

task :default => ["build:parser", "spec"]
