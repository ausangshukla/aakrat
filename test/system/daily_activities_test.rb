require "application_system_test_case"

class DailyActivitiesTest < ApplicationSystemTestCase
  setup do
    @daily_activity = daily_activities(:one)
  end

  test "visiting the index" do
    visit daily_activities_url
    assert_selector "h1", text: "Daily activities"
  end

  test "should create daily activity" do
    visit daily_activities_url
    click_on "New daily activity"

    fill_in "Cost", with: @daily_activity.cost
    fill_in "Details", with: @daily_activity.details
    fill_in "Project", with: @daily_activity.project_id
    fill_in "Status", with: @daily_activity.status
    fill_in "Step", with: @daily_activity.step_id
    fill_in "User", with: @daily_activity.user_id
    click_on "Create Daily activity"

    assert_text "Daily activity was successfully created"
    click_on "Back"
  end

  test "should update Daily activity" do
    visit daily_activity_url(@daily_activity)
    click_on "Edit this daily activity", match: :first

    fill_in "Cost", with: @daily_activity.cost
    fill_in "Details", with: @daily_activity.details
    fill_in "Project", with: @daily_activity.project_id
    fill_in "Status", with: @daily_activity.status
    fill_in "Step", with: @daily_activity.step_id
    fill_in "User", with: @daily_activity.user_id
    click_on "Update Daily activity"

    assert_text "Daily activity was successfully updated"
    click_on "Back"
  end

  test "should destroy Daily activity" do
    visit daily_activity_url(@daily_activity)
    click_on "Destroy this daily activity", match: :first

    assert_text "Daily activity was successfully destroyed"
  end
end
