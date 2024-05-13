class AddInterstitialPromptToPrompts < ActiveRecord::Migration[7.1]
  def change
    add_column :prompts, :interstitial_prompt, :string, default: '{0}'
  end
end
