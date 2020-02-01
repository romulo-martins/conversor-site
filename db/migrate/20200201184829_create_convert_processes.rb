class CreateConvertProcesses < ActiveRecord::Migration[5.2]
  def change
    create_table :convert_processes do |t|
      t.string :name
      t.string :format
      t.string :url
      t.string :status

      t.timestamps
    end
  end
end
