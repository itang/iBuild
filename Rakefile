task :default => :build

task :build => :clean do
  sh 'crystal build src/ibuild.cr -o ~/dev-env/tools/ibuild'
end

task :clean do
  sh 'rm -rf .crystal'
end
