# #
# Rust cargo Project.
# #
module IBuild::Projects
  class Cargo < Project
    BUILD_FILE = "Cargo.toml"

    def self.detect(dir)
      pclj = dir + "/#{BUILD_FILE}"
      File.exists?(pclj)
    end

    def info : ProjectInfo
      lines = File.read(BUILD_FILE).lines
      ProjectInfo.new str_value("name", lines), str_value("version", lines)
    end

    private def str_value(key, lines)
      line = lines.find { |x| x.starts_with?(key) }
      if line
        line = line.strip
        start = line.index("\"")
        line[(start + 1)..-2] if start
      end
    end

    def compile
      sh "cargo build"
    end

    # @Override
    def run
      sh "cargo run"
    end

    # @Override
    def test
      sh "cargo test"
    end

    # @Override
    def repl
      super
    end

    # @Override
    def format
      # @see https://github.com/pwoolcoc/cargo-fmt
      # @see https://github.com/pwoolcoc/cargo-do
      sh "cargo do fmt"
    end

    def clean
      sh "cargo clean"
    end

    def deps_tree
      # @see https://github.com/killercup/cargo-edit
      sh "cargo do list --tree"
    end

    def deps_outdated
      super
    end

    def deps_update
      sh "cargo update"
    end

    # @Override
    def to_s(io)
      io << "Rust Cargo"
    end
  end
end
