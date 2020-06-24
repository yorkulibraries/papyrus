FactoryGirl.define do
  factory :todo_item do
    sequence(:summary) { |n| "Todo List #{n}" }
    association :created_by, factory: :user
    association :item, factory: :item
    association :todo_list, factory: :todo_list
    assigned_to nil
    due_date nil
    status TodoItem::STATUS_NEW
  end

end
