require 'rake'
require 'shellwords'
require 'tmpdir'
require 'tempfile'
require 'trunk_updater/ext_command'

module TrunkUpdater
  class SelfRepository
    class << self
      include TrunkUpdater::ExtCommand

      def update_image_tag(repository, tag)
        Dir.mktmpdir do |dir|
          git "clone --depth 1 #{repository.shellescape} #{dir.shellescape}"
          update_dockerfile(File.join(dir, 'Dockerfile'), tag)

          Dir.chdir dir do
            git "commit -am #{"Update to #{tag}".shellescape}"
            git 'push'
          end
        end
      end

      private

      def update_dockerfile(dockerfile_path, tag)
        new_content =
          File.read(dockerfile_path)
              .sub(%r{^FROM vzvu3k6k/redmine:.+$}, "FROM vzvu3k6k/redmine:#{tag}")
        File.write(dockerfile_path, new_content)
      end

      def git(command)
        Tempfile.open do |f|
          f.write ENV['REDMINE_TRUNK_UPDATER_DEPLOY_KEY']
          f.flush

          # FIXME: vulnerable to MITM attack
          ssh_configure = %(-c core.sshCommand="ssh -i #{f.path.shellescape} -o StrictHostKeyChecking=no")

          cmd "git #{ssh_configure} #{command}", env: {
            'GIT_AUTHOR_NAME' => 'vzvu3k6k (bot)',
            'GIT_AUTHOR_EMAIL' => 'vzvu3k6k+bot@gmail.com',
            'GIT_COMMITTER_NAME' => 'vzvu3k6k (bot)',
            'GIT_COMMITTER_EMAIL' => 'vzvu3k6k+bot@gmail.com'
          }
        end
      end
    end
  end
end
