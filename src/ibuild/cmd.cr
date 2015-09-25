require "colorize"
require "./projects"

include IBuild::Projects

module IBuild
  extend self

  def detect(dir = "."): Project?
    case
    when Phoenix.detect(dir)     then Phoenix.new
    when Mix.detect(dir)         then Mix.new

    when Sbt.detect(dir)         then Sbt.new

    when Ring.detect(dir)        then Ring.new
    when Lein.detect(dir)        then Lein.new

    when SpringBoot.detect(dir)  then SpringBoot.new
    when Mvn.detect(dir)         then Mvn.new

    when Shards.detect(dir)      then Shards.new
    end
  end

  def run(project: Project, cmd: String?)
    case cmd
    when "info", nil       then puts "Project Type: '#{project}', Project Info: #{project.info}\n".colorize(:green)
    when "run"             then project.run()
    when "test"            then project.test()
    when "repl", "console" then project.repl()
    when "format", "fmt"   then project.format()
    when "compile"         then project.compile()
    when "clean"           then project.clean()
    when "deps:outdated"   then project.deps_outdated()
    when "deps:update"     then project.deps_update()
    when "deps:tree"       then project.deps_tree()
    when "git:commit:all"  then project.git_commit_all()
    else
      puts "Unkown task: #{cmd}".colorize(:red)
    end
  end
end
