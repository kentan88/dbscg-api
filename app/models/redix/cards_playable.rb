module Redix
  class CardsPlayable
    def self.zrange(game, player)
      REDIS.zrange(key(game, player), 0, -1)
    end

    def self.zadd(game, player, attrs)
      rank = self.zcount(game, player) + 1
      REDIS.zadd(key(game, player), rank, attrs)
    end

    def self.zrem(game, player, card)
      REDIS.zrem(key(game, player), card)
    end

    def self.zrank(game, player, card)
      REDIS.zrank(key(game, player), card)
    end

    def self.zcount(game, player)
      REDIS.zcount(key(game, player), "-inf", "+inf")
    end

    def self.del(game, player)
      REDIS.del(key(game, player))
    end

    private
    def self.key(game, player)
      "game:#{game.id}:#{player}:cards_playable"
    end
  end
end