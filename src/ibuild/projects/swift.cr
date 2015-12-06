# #
# Rust cargo Project.
# #
module IBuild::Projects
  class Swift < Project
    BUILD_FILE = "Package.swift"

    def self.detect(dir)
      pclj = dir + "/#{BUILD_FILE}"
      File.exists?(pclj)
    end

    def info : ProjectInfo
      # TODO
      ProjectInfo.new "", ""
    end

    def compile
      build
    end

    def build
      sh_with_argv "swift build"
    end

    def run
      super
    end

    # @Override
    def repl
      sh_with_argv "swift"
    end

    # @Override
    def format
      super
    end

    def clean
      sh "swift build --clean"
    end

    def deps_tree
      super
    end

    def deps_outdated
      super
    end

    def deps_update
      super
    end

    def install
      super
    end

    # @Override
    def to_s(io)
      io << "Swift build"
    end
  end
end
