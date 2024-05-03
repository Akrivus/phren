require "application_system_test_case"

class PeopleTest < ApplicationSystemTestCase
  setup do
    @person = people(:one)
  end

  test "visiting the index" do
    visit people_url
    assert_selector "h1", text: "people"
  end

  test "should create person" do
    visit people_url
    click_on "New person"

    fill_in "Name", with: @person.name
    fill_in "Person prompt", with: @person.person_prompt
    fill_in "System prompt", with: @person.system_prompt
    click_on "Create person"

    assert_text "person was successfully created"
    click_on "Back"
  end

  test "should update person" do
    visit person_url(@person)
    click_on "Edit this person", match: :first

    fill_in "Name", with: @person.name
    fill_in "Person prompt", with: @person.person_prompt
    fill_in "System prompt", with: @person.system_prompt
    click_on "Update person"

    assert_text "person was successfully updated"
    click_on "Back"
  end

  test "should destroy person" do
    visit person_url(@person)
    click_on "Destroy this person", match: :first

    assert_text "person was successfully destroyed"
  end
end
