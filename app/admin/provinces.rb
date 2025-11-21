# app/admin/provinces.rb
ActiveAdmin.register Province do
  menu priority: 7, label: "Provinces"

  permit_params :code, :name, :gst_rate, :pst_rate, :hst_rate

  filter :name
  filter :code

  index do
    selectable_column
    id_column
    column :code
    column :name
    column "GST Rate" do |province|
      number_to_percentage(province.gst_rate * 100, precision: 2)
    end
    column "PST Rate" do |province|
      number_to_percentage(province.pst_rate * 100, precision: 2)
    end
    column "HST Rate" do |province|
      number_to_percentage(province.hst_rate * 100, precision: 2)
    end
    column "Total Tax" do |province|
      number_to_percentage(province.total_tax_rate * 100, precision: 2)
    end
    actions
  end

  show do
    attributes_table do
      row :id
      row :code
      row :name
      row "GST Rate" do |province|
        number_to_percentage(province.gst_rate * 100, precision: 2)
      end
      row "PST Rate" do |province|
        number_to_percentage(province.pst_rate * 100, precision: 2)
      end
      row "HST Rate" do |province|
        number_to_percentage(province.hst_rate * 100, precision: 2)
      end
      row "Total Tax Rate" do |province|
        number_to_percentage(province.total_tax_rate * 100, precision: 2)
      end
      row :created_at
      row :updated_at
    end

    panel "Tax Calculation Example ($100.00)" do
      taxes = province.calculate_taxes(100)
      attributes_table_for province do
        row "GST" do
          number_to_currency(taxes[:gst])
        end
        row "PST" do
          number_to_currency(taxes[:pst])
        end
        row "HST" do
          number_to_currency(taxes[:hst])
        end
        row "Total Tax" do
          number_to_currency(taxes[:total])
        end
        row "Grand Total" do
          number_to_currency(100 + taxes[:total])
        end
      end
    end
  end

  form do |f|
    f.semantic_errors
    f.inputs "Province Information" do
      f.input :code, hint: "2-letter province code (e.g., ON, BC, AB)"
      f.input :name
    end
    f.inputs "Tax Rates" do
      f.input :gst_rate, as: :number, step: 0.0001, hint: "Enter as decimal (e.g., 0.05 for 5%)"
      f.input :pst_rate, as: :number, step: 0.0001, hint: "Enter as decimal (e.g., 0.07 for 7%)"
      f.input :hst_rate, as: :number, step: 0.0001, hint: "Enter as decimal (e.g., 0.13 for 13%)"
    end
    f.actions
  end
end
