class CreateTerms < ActiveRecord::Migration[4.2]
  def self.up
    create_table :terms do |t|
      t.string :name
      t.date :start_date
      t.date :end_date
      t.timestamps
    end
  end

  def self.down
    drop_table :terms
  end
end
