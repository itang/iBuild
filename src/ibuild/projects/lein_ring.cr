##
# Clojure Ring Project.
##
module IBuild::Projects
  class Ring < Lein
    def self.detect(dir)
      Lein.detect(dir) && File.read(BUILD_FILE).includes?("lein-ring")
    end

    # @Override
    def run()
      sh "lein ring server"
    end

    # @Override
    def to_s(io)
      io << "Clojure Lein Ring"
    end
  end
end
