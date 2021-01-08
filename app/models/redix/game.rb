module Redix
  class Game
    def self.hgetall(game)
      OpenStruct.new(REDIS.hgetall(key(game)))
    end

    def self.hget(game, key)
      REDIS.hget(key(game), key)
    end

    def self.hset(game, *attrs)
      REDIS.hset(key(game), *attrs)
    end

    private
    def self.key(game)
      "game:#{game.id}"
    end
  end
end