class CreateDocs < ActiveRecord::Migration[6.1]
  def change
    create_table :docs, id: :uuid do |t|
      t.text :topic
      t.text :description

      t.timestamps
    end
  end
end
