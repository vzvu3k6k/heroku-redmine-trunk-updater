require 'rake'
require 'shellwords'
require 'tmpdir'

module TrunkUpdater
  class SelfRepository
    # Rake adds sh method to FileUtils.
    extend FileUtils
    include FileUtils

    def self.update_container(tag)
      Dir.mktmpdir do |tmpdir|
        repo = new(clone_to: tmpdir)
        repo.clone
        repo.update_dockerfile(tag)
        repo.add_and_commit "Update to #{tag}"
        repo.push
      end
    end

    attr_reader :dir

    def initialize(clone_to: dir)
      @dir = dir
    end

    def clone
      sh "git clone --depth 1 git@github.com:vzvu3k6k/heroku-redmine-trunk.git #{dir.shellescape}"
    end

    def update_dockerfile(tag)
      filepath = File.join(dir, 'Dockerfile')
      new_content =
        File.read(filepath)
            .sub(%r{^FROM vzvu3k6k/redmine:.+$}, "FROM vzvu3k6k/redmine:#{tag}")
      File.write(filepath, new_content)
    end

    def add_and_commit(message)
      sh identity_env, "git -C #{dir.shellescape} commit -am #{message.shellescape}"
    end

    def push
      sh "git -C #{dir.shellescape} push"
    end

    def identity_env
      {
        'GIT_AUTHOR_NAME' => 'vzvu3k6k (bot)',
        'GIT_AUTHOR_EMAIL' => 'vzvu3k6k@gmail.com',
        'GIT_COMMITTER_NAME' => 'vzvu3k6k (bot)',
        'GIT_COMMITTER_EMAIL' => 'vzvu3k6k@gmail.com',
      }
    end
  end
end
