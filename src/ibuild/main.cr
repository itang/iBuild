require "colorize"
require "./version"
require "./cmd"

private def main(argv)
  puts "iBuild(I-LOVE-BUILD)-v#{IBuild::VERSION}"

  if project = IBuild.detect()
    cmd = argv[0]?
    IBuild.run(project, "info") unless cmd == "info"
    IBuild.run(project, cmd)
  else
    puts "INFO: in #{Dir.working_directory}".colorize(:blue)
    puts "WARN: Unknown Project".colorize(:red)
  end
end

main(ARGV)
