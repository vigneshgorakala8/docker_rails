# frozen_string_literal: true

if Rails.env.development? || Rails.env.test?
  require "rubocop/rake_task"

  RuboCop::RakeTask.new

  namespace :rubocop do
    desc "Auto-correct RuboCop offenses"
    task :auto_correct do
      sh "bundle exec rubocop -A"
    end

    desc "Run RuboCop with JSON output"
    task :json do
      sh "bundle exec rubocop --format json"
    end

    desc "Run RuboCop on changed files only"
    task :changed do
      changed_files = `git diff --name-only --diff-filter=AM`.split("\n").select { |f| f.end_with?(".rb") }
      if changed_files.any?
        sh "bundle exec rubocop #{changed_files.join(' ')}"
      else
        puts "No Ruby files changed."
      end
    end
  end

  # Add RuboCop to the default test task
  task test: :rubocop if Rails.env.test?
end
