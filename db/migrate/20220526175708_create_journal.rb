class CreateJournal < ActiveRecord::Migration[7.0]
  def change
    create_table :journals do |t|
      t.belongs_to :webhook, null: false, foreign_key: true
      t.string :notes, null: false, default: ''
      t.integer :result, null: false
      t.string :stdin, null: false
      t.string :stdout, null: false
      t.string :stderr, null: false

      t.timestamps
    end
  end
end
