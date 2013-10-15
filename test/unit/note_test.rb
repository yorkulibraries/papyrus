require 'test_helper'

class NoteTest < ActiveSupport::TestCase
  
  should "add a valid note" do
    note = Factory.build(:note)
    assert note.valid?
    
    assert_difference "Note.count", 1 do
      note.save
    end
    
  end
  
  should "not add an invalid note" do
    note = Factory.build(:note, :note => nil)
    
    assert !note.valid?
    
    assert_no_difference "Note.count" do
      note.save
    end
  end
  
  should "be able to update note" do
    note = Factory.create(:note, :note => "old")
    note = Note.find(note.id)
    note.note = "new"
    note.save
    
    note.reload
    assert_equal "new", note.note
  end
    
end
