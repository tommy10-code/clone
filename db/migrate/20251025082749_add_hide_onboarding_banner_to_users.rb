class AddHideOnboardingBannerToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :hide_onboarding_banner, :boolean, default: false, null: false
  end
end
