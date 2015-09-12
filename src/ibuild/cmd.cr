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
    end
  end

  def run(project: Project, cmd: String?)
    case cmd
    when "info"            then puts "Project Type: '#{project}', Project Info: #{project.info}\n".colorize(:green)
    when "run"             then project.run()
    when "test"            then project.test()
    when "repl", "console" then project.repl()
    when "format", "fmt"   then project.format()
    when "compile"         then project.compile()
    when "clean"           then project.clean()
    when nil               then usage()
    else
      puts "Unkown task: #{cmd}".colorize(:red)
      usage()
    end
  end

  private def usage()
    puts "Usage: ibuild task
* task: info | compile | run | test | repl | format | clean".colorize(:yellow)
  end
end
