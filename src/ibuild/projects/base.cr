require "process"
require "uri"
require "json"

module IBuild::Projects
  class ProjectInfo
    getter name, version

    JSON.mapping({
      name:    {type: String, nilable: true},
      version: {type: String, nilable: true},
    })

    def initialize(@name, @version)
    end

    def to_s(io)
      io << self.to_json # "Project(Name=#{name}, Version=#{version})"
    end
  end

  abstract class Project
    abstract def self.detect(dir = ".") : Bool

    abstract def info : ProjectInfo

    macro define_dummy_methods(*names)
      {% for name, index in names %}
        def {{name.id}}
          puts_no_impl_info
        end
      {% end %}
    end

    define_dummy_methods compile, run, start, test, repl, format, clean, deps_tree, deps_outdated, deps_update

    def git_commit_all
      # puts "Confirm(Y?): "
      # ok = gets
      # if ok.try(&.downcase) == 'y'
      sh "git add --all"
      sh %(git commit -m "just commit")
      sh "git push origin master"
      # end
    end

    protected def sh_with_argv(cmd)
      # 传递附加命令行参数
      sh cmd, ARGV[1..-1].join(" ")
    end

    protected def sh(cmd, args = nil)
      cmd1 = (args ? cmd + " " + args : cmd)
      puts cmd1
      system cmd1
    end

    protected def fork_run_browser(cmd : String, url : String)
      target_ps = fork { sh cmd }

      fork do
        port = URI.parse(url).port.try(&.to_u16) || 80_u16
        wait_until_port_open(port) do
          puts "start browser..."
          sh "xdg-open #{url}"
        end
      end

      target_ps.wait
    end

    private def wait_until_port_open(port : UInt16, sleeps = 1, &block)
      while (ret = `lsof -i :#{port}`).empty?
        sleep sleeps
      end
      block.call
    end

    private def puts_no_impl_info
      puts "Do nothing!"
    end
  end
end
