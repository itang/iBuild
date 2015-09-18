##
# Maven Project.
##
require "xml"

module IBuild::Projects
  class Mvn < Project
    BUILD_FILE = "pom.xml"

    def self.detect(dir)
      pxml = dir + "/#{BUILD_FILE}"
      File.exists?(pxml)
    end

    def info: ProjectInfo
      doc = XML.parse(File.read(BUILD_FILE))
      # @IMPROVE: xpath
      root = doc.root
      version_el = root.children.find { |node| node.name == "version" } if root
      name_el = root.children.find { |node| node.name == "name" } if root
      ProjectInfo.new name_el.try(&.text), version_el.try(&.text)
    end

    def compile()
      sh "mvn compile"
    end

    def test()
      sh "mvn test"
    end

    def clean()
      sh "mvn clean"
    end

    def deps_tree()
      sh "mvn dependency:tree"
    end

    def deps_outdated()
      sh "mvn versions:display-dependency-updates"
    end

    def deps_update()
      sh "mvn compile"
    end

    # @Override
    def to_s(io)
      io << "Maven"
    end
  end
end
