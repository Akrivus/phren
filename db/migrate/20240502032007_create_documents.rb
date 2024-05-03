class CreateDocuments < ActiveRecord::Migration[7.1]
  def change
    create_table :documents, id: :uuid do |t|
      t.string :name
      t.string :summary

      t.references :person, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
