class CreateBusinesses < ActiveRecord::Migration[6.1]
  def change
    create_table :businesses, id: :uuid do |t|
      t.text :business_name
      t.uuid :user_id
      t.uuid :industry_id

      t.timestamps
    end
  end
end
