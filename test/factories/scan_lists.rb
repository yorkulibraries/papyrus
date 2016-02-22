FactoryGirl.define do
  factory :scan_list do
    sequence(:name) { |n| "Scan List #{n}" }
    association :created_by, factory: :user
    assigned_to nil
    status ScanList::STATUS_NEW
  end

end
