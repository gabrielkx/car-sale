class AddTitleToCars < ActiveRecord::Migration[7.0]
  def change
    add_column :cars, :title, :string
  end
end
