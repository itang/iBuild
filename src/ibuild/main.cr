require "colorize"
require "./version"
require "./cmd"

private def usage
  puts "iBuild(I-LOVE-BUILD)-v#{IBuild::VERSION}".colorize(:blue)
  puts "Usage: ibuild task
* task: --help,-h | info | compile | run | start | test | repl | format | clean | deps:outdated | deps:update | deps:tree | git:commit:all".colorize(:yellow)
end

private def main(argv)
  cmd = argv[0]?
  case cmd
  when "--help", "-h"
    usage()
  else
    if project = IBuild.detect
      IBuild.run(project, cmd)
    else
      puts "INFO: in #{Dir.working_directory}".colorize(:blue)
      puts "WARN: Unknown Project".colorize(:red)
    end
  end
end

main(ARGV)
