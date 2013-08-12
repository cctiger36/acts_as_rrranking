require 'active_support'
require 'active_record'

module ActsAsRrranking
  extend ActiveSupport::Concern

  module ClassMethods
    def acts_as_rrranking(ranking_key, options = {})
      @ranking_key = ranking_key
      @redis_ranking_key = "#{self.name.underscore}_#{@ranking_key}"
      @score_key = options[:score] || :score
      @ranking_id = options[:id] || :id

      class_eval <<-STR
        def update_#{@ranking_key}
          self.class.redis.zadd('#{@redis_ranking_key}', self.#{@score_key}, self.#{@ranking_id})
        end

        def current_#{@ranking_key}
          if self.#{@score_key} && self.#{@score_key} > 0
            (self.class.redis.zrevrank('#{@redis_ranking_key}', self.#{@ranking_id}) || -1) + 1
          else
            nil
          end
        end

        after_save :update_#{@ranking_key}
      STR

      instance_eval <<-STR
        def top_#{@ranking_key.to_s.pluralize}(limit = 10, offset = 0)
          self.redis.zrange('#{@redis_ranking_key}', -limit - offset, -1 - offset).reverse.map(&:to_i)
        end

        def top_#{@ranking_key}_#{self.name.demodulize.underscore.pluralize}(limit = 10, offset = 0)
          ids = self.top_#{@ranking_key.to_s.pluralize}(limit, offset)
          self.where(#{@ranking_id}: ids).order(self.ranking_order_by_statement(ids))
        end

        def redis_ranking_key
          '#{@redis_ranking_key}'
        end
      STR
    end

    def ranking_order_by_statement(ids)
      case self.db_adapter
      when /^mysql/
        "FIELD(id, #{ids.join(',')})"
      when /^sqlite/
        stat = "CASE id"
        ids.each_with_index do |id, index|
          stat << " WHEN #{id} THEN #{index}"
        end
        stat << " END"
        stat
      else
        raise "Database not supported"
      end
    end

    def db_adapter
      @db_name ||= ActiveRecord::Base.connection_config[:adapter]
    end

    def redis
      @redis ||= Redis.new
    end
  end
end

ActiveRecord::Base.send :include, ActsAsRrranking
