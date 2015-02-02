class AddOfficeDetails < ActiveRecord::Migration
  def change
    add_column :offices, :is_confirmed, :boolean, :default => false 
    add_column :offices, :is_demo, :boolean, :default => false 
    add_column :offices, :main_email, :string 
    add_column :offices, :starter_password, :string  
  end
end
