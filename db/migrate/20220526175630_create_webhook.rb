class CreateWebhook < ActiveRecord::Migration[7.0]
  def change
    create_table :webhooks do |t|
      t.string :path, null: false, index: true
      t.string :application, null: false
      t.string :working_directory, null: false
      t.string :environment, null: false
      t.boolean :enabled, null: false, default: false

      t.timestamps
    end
  end
end
