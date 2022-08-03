require "application_system_test_case"

class MaterialsTest < ApplicationSystemTestCase
  setup do
    @material = materials(:one)
  end

  test "visiting the index" do
    visit materials_url
    assert_selector "h1", text: "Materials"
  end

  test "should create material" do
    visit materials_url
    click_on "New material"

    fill_in "Category", with: @material.category
    fill_in "Cost", with: @material.cost
    fill_in "Description", with: @material.description
    fill_in "Item", with: @material.item
    fill_in "Material", with: @material.material
    fill_in "Quantity", with: @material.quantity
    fill_in "Reminder days before", with: @material.reminder_days_before
    fill_in "Required by date", with: @material.required_by_date
    fill_in "Unit cost", with: @material.unit_cost
    click_on "Create Material"

    assert_text "Material was successfully created"
    click_on "Back"
  end

  test "should update Material" do
    visit material_url(@material)
    click_on "Edit this material", match: :first

    fill_in "Category", with: @material.category
    fill_in "Cost", with: @material.cost
    fill_in "Description", with: @material.description
    fill_in "Item", with: @material.item
    fill_in "Material", with: @material.material
    fill_in "Quantity", with: @material.quantity
    fill_in "Reminder days before", with: @material.reminder_days_before
    fill_in "Required by date", with: @material.required_by_date
    fill_in "Unit cost", with: @material.unit_cost
    click_on "Update Material"

    assert_text "Material was successfully updated"
    click_on "Back"
  end

  test "should destroy Material" do
    visit material_url(@material)
    click_on "Destroy this material", match: :first

    assert_text "Material was successfully destroyed"
  end
end
