module Redix
  class CardInfo
    def self.hgetall(id)
      REDIS.hgetall(key(id))
    end

    def self.hget(game, key)
      REDIS.hget(key(game), key)
    end

    def self.hset(id, *attrs)
      REDIS.hset(id, *attrs)
    end

    private
    def self.key(id)
      "card_info:#{id}"
    end
  end
end