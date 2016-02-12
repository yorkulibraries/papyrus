FactoryGirl.define do
  factory :scan_item do
    sequence(:summary) { |n| "Scan List #{n}" }
    association :created_by, factory: :user
    association :item, factory: :item
    association :scan_list, factory: :scan_list
    assigned_to nil
    due_date nil
    status ScanItem::STATUS_NEW
  end

end
