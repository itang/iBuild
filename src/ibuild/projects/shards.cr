require "yaml"

module IBuild::Projects
  class Shards < Project
    BUILD_FILE = "shard.yml"

    def self.detect(dir)
      File.exists?(BUILD_FILE) || File.exists?("Projectfile")
    end

    def info : ProjectInfo
      if File.exists?(BUILD_FILE)
        lines = File.read(BUILD_FILE).lines
        name = yaml_value_by_key(lines, "name")
        version = yaml_value_by_key(lines, "version")
        ProjectInfo.new(name, version)
      else
        ProjectInfo.new("Unknown project name", "Unknown project version")
      end
    end

    def compile
      build
    end

    def build
      sh_with_argv %(crystal build #{Dir["src/*.cr"].first})
    end

    # @Override
    def run
      sh_with_argv %(crystal run #{Dir["src/*.cr"].first})
    end

    # @Override
    def test
      sh "crystal spec"
    end

    # @Override
    def repl
      super
    end

    # @Override
    def format
      sh "crystal tool format"
    end

    def clean
      super
    end

    def deps_tree
      sh "shards check -v"
    end

    def deps_outdated
      sh "shards check"
    end

    def deps_update
      sh "shards update"
    end

    # @Override
    def to_s(io)
      io << "Crystal"
    end

    private def yaml_value_by_key(lines : Array(String), key : String)
      lines.find { |x| x.starts_with?("#{key}:") }.try { |x| x.split(":")[1]?.try(&.strip) }
    end
  end
end
