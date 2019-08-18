require 'open3'

class SelfRepositoryTest < ActiveSupport::TestCase
  def cmd(command)
    output, sys_exit = Open3.capture2e(command)
    unless sys_exit.success?
      raise "#{command} exited with code #{sys_exit.status}\noutput:\n#{output}"
    end
    output
  end

  test 'update_image_tag' do
    Dir.mktmpdir do |repo|
      Dir.chdir repo do
        cmd 'git init'
        cmd 'git config --local receive.denyCurrentBranch ignore'
        cmd 'git config --local user.name test'
        cmd 'git config --local user.email test@example.com'
        File.write('Dockerfile', 'FROM vzvu3k6k/redmine:r123')
        cmd 'git add -A'
        cmd 'git commit -m "init"'
      end

      # Use `file://` to avoid "--depth is ignored in local clones" warning
      TrunkUpdater::SelfRepository.update_image_tag("file://#{repo}", 'r456')

      Dir.chdir repo do
        cmd 'git reset --hard'

        assert_equal 'FROM vzvu3k6k/redmine:r456', File.read('./Dockerfile')
        assert_equal 'Update to r456', cmd("git log -1 --format='%s'").chomp
      end
    end
  end
end
