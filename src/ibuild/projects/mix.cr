##
# Elixir Mix Project.
##
module IBuild::Projects
  class Mix < Project
    BUILD_FILE = "mix.exs"

    def self.detect(dir)
      File.exists?(dir + "/#{BUILD_FILE}")
    end

    def info: ProjectInfo
      f = File.read(BUILD_FILE)
      clines = f.lines

      name = begin
        ak = "[app: :"
        appline = clines.find {|x| x.includes?(ak)}
        appline.sub(ak, "").gsub(",", "").strip if appline
      end

      version = begin
        vk = %(version: ")
        vline = clines.find {|x| x.includes?(vk)}
        vline.sub(vk, "").gsub("\"", "").gsub(",", "").strip if vline
      end

      ProjectInfo.new name, version
    end

    def compile()
      sh "mix compile"
    end

    def run()
      sh "mix run"
    end

    def test()
      sh "mix test"
    end

    def repl()
      sh "iex -S mix"
    end

    def clean()
      sh "mix clean"
    end

    def to_s(io)
      io << "Elixir Mix"
    end
  end
end
