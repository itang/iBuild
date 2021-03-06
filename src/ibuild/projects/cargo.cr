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
      build
    end

    def build
      sh_with_argv "cargo build"
    end

    # @Override
    def run
      sh_with_argv "cargo run"
    end

    # @Override
    def test
      sh_with_argv "cargo test"
    end

    # @Override
    def repl
      sh_with_argv "rusti"
    end

    # @Override
    def format
      # @see https://github.com/pwoolcoc/cargo-fmt
      # @see https://github.com/pwoolcoc/cargo-do
      sh "cargo fmt"
    end

    def clean
      sh "cargo clean"
    end

    def deps_tree
      # @see https://github.com/killercup/cargo-edit
      sh "cargo list --tree"
    end

    def deps_outdated
      # @see https://github.com/kbknapp/cargo-outdated
      sh_with_argv "cargo outdated"
    end

    def deps_update
      sh "cargo update"
    end

    def install
      sh "cargo install --path ."
    end

    # @Override
    def to_s(io)
      io << "Rust Cargo"
    end
  end
end
