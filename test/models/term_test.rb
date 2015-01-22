require 'test_helper'

class TermTest < ActiveSupport::TestCase
 
   should "add valid Term, where start date < end date and name is present" do
     term = build(:term)  
     assert term.valid?
     assert_difference "Term.count", 1 do
       term.save
     end
   end
   
   should "not add invalid Term with end date < start date" do
     term = build(:term, :end_date => Date.today - 2.months)
     assert !term.valid?
   end   
   
   
   should "only display active terms - end date is >= today"  do
     create(:term, :end_date => Date.today + 1.year, :start_date =>Date.today - 2.years)
     create(:term, :end_date => Date.today + 1.month, :start_date => Date.today - 2.years)
     create(:term, :end_date => Date.today, :start_date => Date.today - 1.month)
     create(:term, :end_date => Date.today - 2.months, :start_date => Date.today - 2.years )
     
     assert_equal 4, Term.all.size
     assert_equal 3, Term.active.size

   end
 
   should "only display archived terms - end date < today " do
      create(:term, :end_date => Date.today + 1.year, :start_date =>Date.today - 2.years)
      create(:term, :end_date => Date.today + 1.month, :start_date => Date.today - 2.years)
      create(:term, :end_date => Date.today, :start_date => Date.today - 1.month)
      create(:term, :end_date => Date.today - 2.months, :start_date => Date.today - 2.years )

      assert_equal 4, Term.all.size
      assert_equal 1, Term.archived.size
   end
end
