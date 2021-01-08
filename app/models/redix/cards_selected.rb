module Redix
  class CardsSelected
    def self.zrange(game, player, area)
      REDIS.zrange(key(game, player, area), 0, -1)
    end

    def self.zadd(game, player, area, attrs)
      rank = self.zcount(game, player, area) + 1
      REDIS.zadd(key(game, player, area), rank, attrs)
    end

    def self.zrem(game, player, area, card)
      REDIS.zrem(key(game, player, area), card)
    end

    def self.zrank(game, player, area, card)
      REDIS.zrank(key(game, player, area), card)
    end

    def self.zcount(game, player, area)
      REDIS.zcount(key(game, player, area), "-inf", "+inf")
    end

    def self.del(game, player, area)
      REDIS.del(key(game, player, area))
    end

    private
    def self.key(game, player, area)
      "game:#{game.id}:#{player}:#{area}:cards_selected"
    end
  end
end