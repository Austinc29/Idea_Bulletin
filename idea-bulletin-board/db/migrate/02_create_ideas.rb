class CreateIdeas < ActiveRecord::Migration
    def change
      create_table :ideas do |t|
        t.string :content
        t.integer :user_id
      end
    end
  end