require "test_helper"

class MaterialsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @material = materials(:one)
  end

  test "should get index" do
    get materials_url
    assert_response :success
  end

  test "should get new" do
    get new_material_url
    assert_response :success
  end

  test "should create material" do
    assert_difference("Material.count") do
      post materials_url, params: { material: { category: @material.category, company_id: @material.company_id, cost: @material.cost, description: @material.description, item: @material.item, material: @material.material, owner_id: @material.owner_id, owner_type: @material.owner_type, project_id: @material.project_id, quantity: @material.quantity, reminder_days_before: @material.reminder_days_before, required_by_date: @material.required_by_date, unit_cost: @material.unit_cost } }
    end

    assert_redirected_to material_url(Material.last)
  end

  test "should show material" do
    get material_url(@material)
    assert_response :success
  end

  test "should get edit" do
    get edit_material_url(@material)
    assert_response :success
  end

  test "should update material" do
    patch material_url(@material), params: { material: { category: @material.category, company_id: @material.company_id, cost: @material.cost, description: @material.description, item: @material.item, material: @material.material, owner_id: @material.owner_id, owner_type: @material.owner_type, project_id: @material.project_id, quantity: @material.quantity, reminder_days_before: @material.reminder_days_before, required_by_date: @material.required_by_date, unit_cost: @material.unit_cost } }
    assert_redirected_to material_url(@material)
  end

  test "should destroy material" do
    assert_difference("Material.count", -1) do
      delete material_url(@material)
    end

    assert_redirected_to materials_url
  end
end
