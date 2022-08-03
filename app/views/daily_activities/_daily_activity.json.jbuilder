json.extract! daily_activity, :id, :user_id, :project_id, :step_id, :details, :status, :cost, :created_at, :updated_at
json.url daily_activity_url(daily_activity, format: :json)
