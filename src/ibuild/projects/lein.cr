# #
# Clojure Lein Project.
# #
module IBuild::Projects
  class Lein < Project
    BUILD_FILE = "project.clj"

    def self.detect(dir)
      pclj = dir + "/#{BUILD_FILE}"
      File.exists?(pclj)
    end

    def info : ProjectInfo
      first_line = File.read(BUILD_FILE).lines[0]
      _, name, version = first_line.split /\s+/
      ProjectInfo.new name, version[1..-2]
    end

    def compile
      sh "lein compile"
    end

    # @Override
    def run
      sh "lein run"
    end

    # @Override
    def test
      sh "lein test"
    end

    # @Override
    def repl
      sh "lein repl"
    end

    # @Override
    def format
      sh "lein cljfmt fix"
    end

    def clean
      sh "lein clean"
    end

    def deps_tree
      sh "lein deps :tree"
    end

    def deps_outdated
      sh "lein ancient"
    end

    def deps_update
      sh "lein deps"
    end

    # @Override
    def to_s(io)
      io << "Clojure Lein"
    end
  end
end
