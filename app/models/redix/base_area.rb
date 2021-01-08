require 'date'

module Redix
  class BaseArea
    def self.zrange(game, player)
      card_ids = REDIS.zrange(key(game, player), 0, -1)

      card_ids.map do |card_id|
        card_state = Redix::PlayerCard.hgetall(game, player, card_id)

        card_number = card_id.split("__")[0]
        { "id" => card_id, "number" => card_number, "mode" => card_state["mode"] }
      end
    end

    def self.zadd(game, player, attrs)
      rank = DateTime.now.strftime('%Q')
      REDIS.zadd(key(game, player), rank, attrs)
    end

    def self.zrem(game, player, card)
      REDIS.zrem(key(game, player), card)
    end

    def self.zcount(game, player)
      REDIS.zcount(key(game, player), "-inf", "+inf")
    end

    # def self.zrevrangebyscore(game, player)
    #   REDIS.zrevrangebyscore(key(game, player), "-inf", "+inf")
    # end

    def self.del(game, player)
      REDIS.del(key(game, player))
    end

    private
    def self.key(game, player)
      name = self.name.to_s.split("::")[1].downcase
     "game:#{game.id}:#{player}:#{name}"
    end
  end
end