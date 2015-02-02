class AddBelongsToAssociationToOffice < ActiveRecord::Migration
  def change
    add_column :accounts,  :office_id, :integer
    add_column :bookings,  :office_id, :integer
    add_column :calendars,  :office_id, :integer
    add_column :customers,  :office_id, :integer
    add_column :incomes,  :office_id, :integer
    add_column :price_details,  :office_id, :integer
    add_column :price_rules,  :office_id, :integer
    add_column :prices,  :office_id, :integer
    add_column :salvage_bookings,  :office_id, :integer
    add_column :transaction_activities,  :office_id, :integer
    add_column :transaction_activity_entries,  :office_id, :integer
    add_column :users,  :office_id, :integer 
    
  end
end
