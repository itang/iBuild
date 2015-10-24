# #
# SBT Project.
# #
module IBuild::Projects
  class Sbt < Project
    BUILD_FILE = "build.sbt"

    # @Override
    def self.detect(dir)
      File.exists?(dir + "/#{BUILD_FILE}")
    end

    def info : ProjectInfo
      pf = File.read(BUILD_FILE)
      m = pf.match /.*name := "(.+)".+version := "(.+)".+scalaVersion.+/m
      if m
        name, version = m[1], m[2]
        ProjectInfo.new name, version
      else
        raise "Error, can't get project info!"
      end
    end

    # @Override
    def run
      case
      when File.read("project/plugins.sbt") =~ /.+sbt-revolver.+/
        fork_run_browser(%(sbt "~re-start"), "http://localhost:8888")
      else
        sh "sbt run"
      end
    end

    # @Override
    def test
      sh "sbt test"
    end

    # @Override
    def repl
      sh "sbt console"
    end

    def clean
      sh "sbt clean"
    end

    def deps_outdated
      sh "sbt dependencyUpdates"
    end

    def deps_tree
      sh "sbt dependencyGraph"
    end

    def deps_update
      sh "sbt compile"
    end

    # @Override
    def to_s(io)
      io << "Scala SBT"
    end
  end
end
