json.extract! material, :id, :company_id, :project_id, :owner_id, :owner_type, :category, :item, :material, :description, :quantity, :unit_cost, :cost, :required_by_date, :reminder_days_before, :created_at, :updated_at
json.url material_url(material, format: :json)
