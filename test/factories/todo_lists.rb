FactoryGirl.define do
  factory :todo_list do
    sequence(:name) { |n| "Todo List #{n}" }
    association :created_by, factory: :user
    assigned_to nil
    status TodoList::STATUS_NEW
  end
end
