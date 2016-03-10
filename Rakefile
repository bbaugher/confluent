# coding: UTF-8
require "English"

VERSION_WITH_NAME_REGEX = /version\s*'\d+\.\d+\.\d+'/
VERSION_REGEX = /\d+\.\d+\.\d+/

REPO = "bbaugher/confluent".freeze

task :release do
  require 'octokit'

  version = cookbook_version

  # Update change log
  puts "Updating change log ..."
  update_change_log version
  puts "Change log updated!"

  # Share the cookbook
  puts "Sharing cookbook ..."
  run_command "bundle exec stove --no-git"
  puts "Shared cookbook!"

  # Tag the release
  puts "Tagging the #{version} release ..."
  run_command "git tag -a #{version} -m 'Released #{version}'"
  run_command "git push origin #{version}"
  puts "Release tagged!"

  # Bump version
  versions = version.split "."
  versions[1] = versions[1].to_i + 1

  # Reset bug number if available
  if versions.size == 3
    versions[2] = 0
  end

  new_version = versions.join "."

  puts "Updating version from #{version} to #{new_version} ..."
  update_cookbook_version new_version
  puts "Version updated!"

  # Commit the updated VERSION file
  puts "Commiting the new version ..."
  run_command "git add metadata.rb"
  run_command "git commit -m 'Released #{version} and bumped version to #{new_version}'"
  run_command "git push origin HEAD"
  puts "Version commited!"
end

task :build_change_log do
  closed_milestones = Octokit.milestones REPO, {:state => "closed"}

  version_to_milestone = Hash.new
  versions = Array.new

  closed_milestones.each do |milestone|
    version = Gem::Version.new(milestone.title)
    version_to_milestone.store version, milestone
    versions.push version
  end

  versions = versions.sort.reverse

  change_log = File.open('CHANGELOG.md', 'w')

  begin
    change_log.write "Change Log\n"
    change_log.write "==========\n"
    change_log.write "\n"

    versions.each do |version|
      milestone = version_to_milestone[version]
      change_log.write generate_milestone_markdown(milestone)
      change_log.write "\n"
    end
  ensure
    change_log.close
  end
end

# Style tests. Rubocop and Foodcritic
namespace :style do
  begin
    require 'foodcritic'

    desc 'Run Chef style checks'
    task :foodcritic do
      FoodCritic::Rake::LintTask.new(:chef) do |t|
        puts 'Running Foodcritic...'
        t.options = {
          fail_tags: ['any']
        }
      end
    end
  rescue LoadError
    puts '>>>>> foodcritic gem not loaded, omitting tasks' unless ENV['CI']
  end

  begin
    require 'rubocop/rake_task'
    desc 'Run Ruby style checks'
    RuboCop::RakeTask.new(:ruby)
  rescue LoadError
    puts '>>>>> Rubocop gem not loaded, omitting tasks' unless ENV['CI']
  end
end

namespace :unit do
  begin
    require 'rspec/core/rake_task'
    desc 'Runs specs with chefspec.'
    RSpec::Core::RakeTask.new(:rspec)
  rescue LoadError
    puts '>>>>> chefspec gem not loaded, omitting tasks' unless ENV['CI']
  end
end

# Integration tests. Kitchen.ci
namespace :integration do
  begin
    desc 'Run Test Kitchen integration tests'
    task :kitchen do
      require 'kitchen'
      Kitchen.logger = Kitchen.default_file_logger
      Kitchen::Config.new.instances.each do |instance|
        instance.test(:always)
      end
    end
  rescue LoadError
    puts '>>>>> kitchen gem not loaded, omitting tasks' unless ENV['CI']
  end
end

desc 'Run all style checks'
task style: ['style:foodcritic', 'style:ruby']

desc 'Run all unit tests'
task unit: ['unit:rspec']

desc 'Run all tests including test Kitchen with Vagrant'
task default: ['unit', 'style', 'integration:kitchen']

def cookbook_version
  # Read in the metadata file
  metadata = IO.read(File.join(File.dirname(__FILE__), 'metadata.rb')).chomp
  version_with_name = VERSION_WITH_NAME_REGEX.match(metadata)[0]
  VERSION_REGEX.match(version_with_name)[0]
end

def update_cookbook_version version
  # Read in the metadata file
  metadata = IO.read(File.join(File.dirname(__FILE__), 'metadata.rb')).chomp
  version_with_name = VERSION_WITH_NAME_REGEX.match(metadata)[0]

  index_to_version_info = metadata.index VERSION_WITH_NAME_REGEX
  # Have to subtract 1 to not include the first '
  index_to_version = version_with_name.index(VERSION_REGEX) - 1

  File.open("metadata.rb", 'w') { |file|
    file.write metadata[0, index_to_version_info + index_to_version]
    file.write "'#{version}'\n"
  }
end

def update_change_log version
  change_log_lines = IO.read(File.join(File.dirname(__FILE__), 'CHANGELOG.md')).split("\n")

  change_log = File.open('CHANGELOG.md', 'w')

  begin

    # Keep change log title
    change_log.write change_log_lines.shift
    change_log.write "\n"
    change_log.write change_log_lines.shift
    change_log.write "\n"
    change_log.write "\n"

    # Write new milestone info
    change_log.write generate_milestone_markdown(milestone(version))

    # Add previous change log info
    change_log_lines.each do |line|
      change_log.write line
      change_log.write "\n"
    end

  ensure
    change_log.close
  end

  run_command "git add CHANGELOG.md"
  run_command "git commit -m 'Added #{version} to change log'"
  run_command "git push origin HEAD"
end

def generate_milestone_markdown milestone
  strings = Array.new

  title = "[#{milestone.title} - #{milestone.updated_at.strftime("%m-%d-%Y")}](https://github.com/#{REPO}/issues?milestone=#{milestone.number}&state=closed)"

  strings.push title
  strings.push "-" * title.length
  strings.push ""

  issues = Octokit.issues REPO, {:milestone => milestone.number, :state => "closed"}

  issues.each do |issue|
    strings.push "  * [#{issue_type issue}] [Issue-#{issue.number}](https://github.com/#{REPO}/issues/#{issue.number}) : #{issue.title}"
  end

  strings.push ""

  strings.join "\n"
end

def milestone version
  closedMilestones = Octokit.milestones REPO, {:state => "closed"}

  closedMilestones.each do |milestone|
    if milestone["title"] == version
      return milestone
    end
  end

  openMilestones = Octokit.milestones REPO

  openMilestones.each do |milestone|
    if milestone["title"] == version
      return milestone
    end
  end

  raise "Unable to find milestone with title [#{version}]"
end

def issue_type issue
  labels = Array.new
  issue.labels.each do |label|
    labels.push label.name.capitalize
  end
  labels.join "/"
end

def run_command command
  output = `#{command}`
  unless $CHILD_STATUS.success?
    raise "Command : [#{command}] failed.\nOutput : \n#{output}"
  end
end
