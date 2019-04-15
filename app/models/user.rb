class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  skip_callback :validation, :before, :downcase_keys, if: :guest

  before_validation :strip_name

  validates :displaying_name, presence: true, length: { maximum: 25 }

  def to_s
    "#{id}: #{email} - #{displaying_name}"
  end

  private

  def strip_name
    displaying_name&.strip!
  end
end
