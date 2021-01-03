module DBSCG
  class Card
    attr_reader :number

    def initialize(opts)
      @number = opts[:number]
    end
  end
end

