require 'open3'

module TrunkUpdater
  module ExtCommand
    def cmd(command)
      output, sys_exit = Open3.capture2e(command)
      unless sys_exit.success?
        raise "#{command} exited with code #{sys_exit}\noutput:\n#{output}"
      end
      output
    end
  end
end
