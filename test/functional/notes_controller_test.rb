require 'test_helper'

class NotesControllerTest < ActionController::TestCase

  context "as admin" do
    setup do
      @admin_user = create(:user, :role => User::ADMIN)
      @student = create(:student)
      log_user_in(@admin_user)
    end

    should "be able to create a new note for student" do
       assert_difference "Note.count", 1 do
          attrs = attributes_for(:note, :student => @student, :user => @admin_user)
          post :create, {:note => attrs, :student_id => @student.id }
        end

        assert_redirected_to student_notes_path(@student)
    end

    should "be able to update note within #{Note.EDIT_TIME / 60} minutes" do
      note = create(:note, :student => @student, :user => @admin_user)

      note.note = "changed"

      post :update, {:id => note.id, :note => {:note => note.note }, :student_id => @student.id }

      assert_redirected_to student_notes_path(@student)

      note.reload

      assert_equal "changed", note.note

    end

    should "redirect to notes list with error mesage if updating after #{Note.EDIT_TIME / 60} minutes" do
      note = create(:note, :created_at => Time.now - 2.days, :student => @student)
      note.reload

      post :edit, {:id => note.id, :student_id => @student.id}

      assert_redirected_to student_notes_path(@student)

      assert_equal "Time to edit the note has ended.", flash[:alert]
    end

    should "be not be able to update note after #{Note.EDIT_TIME / 60} minutes" do
      note = create(:note, :created_at => Time.now - 6.minutes, :student => @student )

      post :update, { :id => note.id, :student_id => @student.id, :note => { :note => note.note } }

      assert_redirected_to student_notes_path(@student)

      assert_equal "Time to edit the note has ended.", flash[:alert]

    end

    should "be able to delete the notes" do

      note = create(:note, :student => @student)

       assert_difference "Note.count", -1 do
          post :destroy, {:id => note.id, :student_id => @student.id}
       end

       assert_redirected_to student_notes_path(@student)
    end

    should "list all the notes for student" do
      note = create(:note, :student => @student)
      note2 = create(:note, :student => @student)

      get :index, :student_id => @student.id

      assert assigns(:notes), "Doesn't assign the notes"
      notes = assigns(:notes)
      assert_equal 2, notes.size, "Count is different"

    end

  end

end
