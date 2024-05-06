require "application_system_test_case"

class PromptsTest < ApplicationSystemTestCase
  setup do
    @prompt = prompts(:one)
  end

  test "visiting the index" do
    visit prompts_url
    assert_selector "h1", text: "prompts"
  end

  test "should create prompt" do
    visit prompts_url
    click_on "New prompt"

    fill_in "Name", with: @prompt.name
    fill_in "Person prompt", with: @prompt.person_prompt
    fill_in "System prompt", with: @prompt.system_prompt
    click_on "Create prompt"

    assert_text "prompt was successfully created"
    click_on "Back"
  end

  test "should update prompt" do
    visit prompt_url(@prompt)
    click_on "Edit this prompt", match: :first

    fill_in "Name", with: @prompt.name
    fill_in "Person prompt", with: @prompt.person_prompt
    fill_in "System prompt", with: @prompt.system_prompt
    click_on "Update prompt"

    assert_text "prompt was successfully updated"
    click_on "Back"
  end

  test "should destroy prompt" do
    visit prompt_url(@prompt)
    click_on "Destroy this prompt", match: :first

    assert_text "prompt was successfully destroyed"
  end
end
