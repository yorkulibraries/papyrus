require 'test_helper'

class StudentDetailsTest < ActiveSupport::TestCase
  should 'create a valid student details' do
    student_details = build(:student_details)

    assert student_details.valid?, 'Should be valid by default'

    assert_difference 'StudentDetails.count', 1 do
      student_details.save
    end
  end

  should 'not create an invalid student details' do
    assert !build(:student_details, student_number: nil).valid?, 'Student Number is required'
    assert !build(:student_details, preferred_phone: nil).valid?, 'preferred_phone is required'
    # assert ! build(:student_details, cds_counsellor: nil).valid?, "CDS councillor is required"
    assert !build(:student_details, transcription_coordinator: nil).valid?, 'Transcription Coordinator is required'
    assert !build(:student_details, transcription_assistant: nil).valid?, 'Transcription Assistant is required'

    student_details = build(:student_details, preferred_phone: nil, cds_counsellor: nil)
    assert_no_difference 'StudentDetails.count' do
      student_details.save
    end
  end

  should 'be able to update student details' do
    details = create(:student_details, student_number: 12_323, cds_counsellor: 'some dude', preferred_phone: '393939')

    details.student_number = 111
    details.preferred_phone = '122'
    details.cds_counsellor = 'one dude'
    details.save

    details.reload
    assert_equal 111, details.student_number
    assert_equal 'one dude', details.cds_counsellor
    assert_equal '122', details.preferred_phone
  end

  should 'be able to delete student details' do
    details = create(:student_details)

    assert_difference 'StudentDetails.count', -1 do
      details.destroy
    end
  end

  should 'complete orientation, set the field to true and add a date' do
    details = create(:student_details, orientation_completed: false, orientation_completed_at: nil)

    details.complete_orientation
    assert details.orientation_completed, 'Orientation completed should be set to true'
    assert_not_nil details.orientation_completed_at, 'A date should be recorded'
  end
end
