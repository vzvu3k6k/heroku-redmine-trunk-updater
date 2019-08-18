require 'rake'
require 'shellwords'
require 'tmpdir'

module TrunkUpdater
  class SelfRepository
    class << self
      # Rake adds sh method to FileUtils.
      include FileUtils

      def update_image_tag(repository, tag)
        Dir.mktmpdir do |dir|
          sh "git clone --depth 1 #{repository.shellescape} #{dir.shellescape}"
          update_dockerfile(File.join(dir, 'Dockerfile'), tag)

          chdir dir do
            sh git_identity_env, "git -C #{dir.shellescape} commit -am #{"Update to #{tag}".shellescape}"
            sh "git -C #{dir.shellescape} push"
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

      def git_identity_env
        {
          'GIT_AUTHOR_NAME' => 'vzvu3k6k (bot)',
          'GIT_AUTHOR_EMAIL' => 'vzvu3k6k@gmail.com',
          'GIT_COMMITTER_NAME' => 'vzvu3k6k (bot)',
          'GIT_COMMITTER_EMAIL' => 'vzvu3k6k@gmail.com',
        }
      end
    end
  end
end
