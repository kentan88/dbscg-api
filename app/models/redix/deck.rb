module Redix
  class Deck
    def self.lrange(game, player)
      REDIS.lrange(key(game, player), 0, -1)
    end

    def self.rpush(game, player, attrs)
      REDIS.rpush(key(game, player), attrs)
    end

    def self.del(game, player)
      REDIS.del(key(game, player))
    end

    def self.lpop(game, player)
      REDIS.lpop(key(game, player))
    end

    private
    def self.key(game, player)
      "game:#{game.id}:#{player}:deck"
    end
  end
end