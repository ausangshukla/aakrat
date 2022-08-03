require "test_helper"

class DailyActivitiesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @daily_activity = daily_activities(:one)
  end

  test "should get index" do
    get daily_activities_url
    assert_response :success
  end

  test "should get new" do
    get new_daily_activity_url
    assert_response :success
  end

  test "should create daily_activity" do
    assert_difference("DailyActivity.count") do
      post daily_activities_url, params: { daily_activity: { cost: @daily_activity.cost, details: @daily_activity.details, project_id: @daily_activity.project_id, status: @daily_activity.status, step_id: @daily_activity.step_id, user_id: @daily_activity.user_id } }
    end

    assert_redirected_to daily_activity_url(DailyActivity.last)
  end

  test "should show daily_activity" do
    get daily_activity_url(@daily_activity)
    assert_response :success
  end

  test "should get edit" do
    get edit_daily_activity_url(@daily_activity)
    assert_response :success
  end

  test "should update daily_activity" do
    patch daily_activity_url(@daily_activity), params: { daily_activity: { cost: @daily_activity.cost, details: @daily_activity.details, project_id: @daily_activity.project_id, status: @daily_activity.status, step_id: @daily_activity.step_id, user_id: @daily_activity.user_id } }
    assert_redirected_to daily_activity_url(@daily_activity)
  end

  test "should destroy daily_activity" do
    assert_difference("DailyActivity.count", -1) do
      delete daily_activity_url(@daily_activity)
    end

    assert_redirected_to daily_activities_url
  end
end
