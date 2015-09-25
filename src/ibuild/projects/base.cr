require "process"
require "uri"
require "json"

module IBuild::Projects
  class ProjectInfo
    getter name, version

    json_mapping({
      name: {type: String, nilable: true},
      version: {type: String, nilable: true}
    })

    def initialize(@name, @version)
    end

    def to_s(io)
      io << self.to_json # "Project(Name=#{name}, Version=#{version})"
    end
  end

  abstract class Project
    abstract def self.detect(dir = "."): Bool

    abstract def info(): ProjectInfo

    def compile()
      puts_no_impl_info
    end

    def run()
      puts_no_impl_info
    end

    def test()
      puts_no_impl_info
    end

    def repl()
      puts_no_impl_info
    end

    def format()
      puts_no_impl_info
    end

    def clean()
      puts_no_impl_info
    end

    def deps_tree()
      puts_no_impl_info
    end

    def deps_outdated()
      puts_no_impl_info
    end

    def deps_update()
      puts_no_impl_info
    end

    def git_commit_all()
      #puts "Confirm(Y?): "
      #ok = gets
      #if ok.try(&.downcase) == 'y'
        sh "git add --all"
        sh %(git commit -m "just commit")
        sh "git push origin master"
      #end
    end

    protected def sh(cmd)
      puts cmd
      system cmd
    end

    protected def fork_run_browser(cmd: String, url: String)
      target_ps = fork { sh cmd }

      fork do
        port = URI.parse(url).port.try(&.to_u16) || 80_u16
        wait_until_port_open(port) do
          puts "start browser..."
          sh "xdg-open #{url}"
        end
      end

      target_ps.wait()
    end

    private def wait_until_port_open(port: UInt16, sleeps = 1, &block)
      while (ret=`lsof -i :#{port}`).empty?
        sleep sleeps
      end
      block.call
    end

    private def puts_no_impl_info()
      puts "Do nothing!"
    end
  end
end
