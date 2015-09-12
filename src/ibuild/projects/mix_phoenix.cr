##
# Elixir Phoenix Project.
##
module IBuild::Projects
  class Phoenix < Mix
    BUILD_FILE = "mix.exs"

    def self.detect(dir)
      Mix.detect(dir) && File.exists?(dir + "/package.json")
    end

    def run()
      fork_run_browser("mix phoniex.server", "http://localhost:4000")
    end

    def to_s(io)
      io << "Elixir Mix Phoenix"
    end
  end
end
