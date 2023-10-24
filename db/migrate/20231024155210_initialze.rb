class Initialze < ActiveRecord::Migration[7.1]
  def change
    create_enum "account_type", ["customer", "vendor"]

    create_table "accounts", force: :cascade do |t|
      t.enum "account_types", array: true, enum_type: "account_type"
    end

  end
end
