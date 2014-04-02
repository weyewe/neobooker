class AddHolidayPriceRule < ActiveRecord::Migration
  def change
    add_column :price_rules,  :holiday_date, :datetime
    add_column :price_rules,  :is_holiday, :boolean, :default => false 
  end
end
