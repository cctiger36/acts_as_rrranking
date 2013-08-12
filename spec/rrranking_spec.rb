require 'spec_helper'
require 'active_record'

ActiveRecord::Base.establish_connection(
  :adapter => 'sqlite3',
  :database => File.expand_path(File.dirname(__FILE__) + '/rrranking_test.sqlite3')
)

class CreatePlayers < ActiveRecord::Migration
  def self.up
    create_table :players do |t|
      t.string :name
      t.integer :game_point
      t.timestamps
    end
  end

  def self.down
    drop_table :players
  end
end

class Player < ActiveRecord::Base
  acts_as_rrranking :ranking, score: :game_point
end

describe Player do
  before do
    CreatePlayers.up
  end

  after do
    CreatePlayers.down
    Redis.new.del(Player.redis_ranking_key)
  end

  10.times { |i| let("player#{i}".to_sym) { FactoryGirl.create(:player) } }

  it "should generate instance methods" do
    player0.should respond_to :current_ranking, :update_ranking
  end

  it "should generate class methods" do
    Player.should respond_to :top_rankings, :top_ranking_players
  end

  it "should remove ranking data from redis when model destroyed" do
    player0.update_attributes!(game_point: 10)
    player0.destroy
    Player.redis.zrevrank(Player.redis_ranking_key, player0.id).should be_nil
  end

  describe "::redis_ranking_key" do
    it "should generate redis key" do
      Player.redis_ranking_key.should == "player_ranking"
    end
  end

  describe "::remove_all_redis_ranking_data" do
    it "should remove all ranking data in redis" do
      10.times { |i| send("player#{i}").send(:update_attributes!, game_point: i + 1) }
      Player.redis.zcount(Player.redis_ranking_key, '-inf', '+inf').should > 0
      Player.remove_all_redis_ranking_data
      Player.redis.zcount(Player.redis_ranking_key, '-inf', '+inf').should == 0
    end
  end

  describe "#current_ranking" do
    it "should be nil when score is nil or score <= 0" do
      player0.current_ranking.should be_nil
      player0.game_point = nil
      player0.current_ranking.should be_nil
    end

    it "should be 1 when the highest score" do
      player1.update_attributes!(game_point: 10)
      player1.current_ranking.should == 1
    end

    it "should return the ranking" do
      10.times { |i| send("player#{i}").send(:update_attributes!, game_point: i + 1) }
      10.times { |i| send("player#{i}").current_ranking.should == 10 - i }
    end
  end

  context "get tops" do
    before do
      10.times { |i| send("player#{i}").send(:update_attributes!, game_point: i + 1) }
    end

    describe "::top_rankings" do
      it "should return the highest score player's ids" do
        Player.top_rankings(3).should == [player9.id, player8.id, player7.id]
      end
    end

    describe "::top_ranking_players" do
      it "should return Player instances" do
        Player.top_ranking_players(3).each do |player|
          player.should be_an_instance_of Player
        end
      end

      it "should return the highest score players" do
        Player.top_ranking_players(3).map(&:id).should == [player9.id, player8.id, player7.id]
      end
    end
  end
end
