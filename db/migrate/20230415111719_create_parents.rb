class CreateParents < ActiveRecord::Migration[6.1]
  def change
    create_table :parents do |t|
      #t.string :occupation # translated

      t.timestamps
    end
    reversible do |dir|
      dir.up do
        Parent.create_translation_table! occupation: :string
      end

      dir.down do
        Parent.drop_translation_table!
      end
    end
  end
end
