class Category < ApplicationRecord
  has_many :shops

    # 検索に使える属性（column）の許可
  def self.ransackable_attributes(auth_object = nil)
    %w[name created_at updated_at]
  end
end
