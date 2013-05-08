FactoryGirl.define do
  factory :player do
    sequence(:id) { |n| n + 1 }
    sequence(:name) { |n| "player#{n}" }
    game_point 0
  end
end
