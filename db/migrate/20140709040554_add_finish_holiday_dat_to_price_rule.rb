class AddFinishHolidayDatToPriceRule < ActiveRecord::Migration
  def change
    add_column :price_rules,  :finish_holiday_date, :datetime
  end
end
