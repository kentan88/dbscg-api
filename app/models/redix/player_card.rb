module Redix
  class PlayerCard
    def self.hgetall(game, player, card)
      REDIS.hgetall(key(game, player, card))
    end

    def self.hset(game, player, card, *attrs)
      REDIS.hset(key(game, player, card), *attrs.concat([PLAYER, player]))
    end

    private
    def self.key(game, player, card)
      name = self.name.to_s.split("::")[1].downcase
      "game:#{game.id}:#{player}:#{name}:#{card}"
    end
  end
end