FactoryGirl.define do
  factory :scan_list do
    name "MyString"
    created_by_id 1
    status ScanList::STATUS_NEW
  end

end
