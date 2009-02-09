
require 'daemons'

require 'etc'
require 'fileutils'

module AppDeploy

  module Daemon
    module_function
    def daemonize pid_path, log_path, user, group, chdir
      Dir.chdir(chdir) if chdir

      user  ||= Etc.getpwuid(Process.uid).name
      group ||= Etc.getpwuid(Process.gid).name

      Daemon.change_privilege(user, group)

      cwd = Dir.pwd
      ::Daemonize.daemonize(log_path)
      Dir.chdir(cwd)

      Daemon.write_pid(pid_path)

      at_exit{
        puts "Stopping #{pid_path}..."
        Daemon.remove_pid(pid_path)
      }
    end

    # extracted from thin
    # Change privileges of the process
    # to the specified user and group.
    def change_privilege user, group

      uid, gid = Process.euid, Process.egid
      target_uid = Etc.getpwnam(user).uid
      target_gid = Etc.getgrnam(group).gid

      if uid != target_uid || gid != target_gid
        puts "Changing process privilege to #{user}:#{group}"

        # Change process ownership
        Process.initgroups(user, target_gid)
        Process::GID.change_privilege(target_gid)
        Process::UID.change_privilege(target_uid)
      end

    rescue Errno::EPERM => e
      puts "Couldn't change user and group to #{user}:#{group}: #{e}"
    end

    def write_pid path
      FileUtils.mkdir_p(File.dirname(path))
      File.open(path, 'w'){ |f| f.write(Process.pid) }
      File.chmod(0644, path)
    end

    def remove_pid path
      File.delete(path) if File.exist?(path)
    end

  end # of Daemon
end # of AppDeploy
