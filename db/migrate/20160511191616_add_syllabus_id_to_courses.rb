# frozen_string_literal: true

class AddSyllabusIdToCourses < ActiveRecord::Migration[4.2]
  def change
    add_column :courses, :syllabus_id, :integer
  end
end
