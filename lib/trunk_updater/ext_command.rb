require 'open3'

module TrunkUpdater
  module ExtCommand
    def cmd(command, env: nil)
      output, sys_exit =
        if env
          Open3.capture2e(env, command)
        else
          Open3.capture2e(command)
        end
      unless sys_exit.success?
        raise "#{command} exited with code #{sys_exit}\noutput:\n#{output}"
      end
      output
    end
  end
end
