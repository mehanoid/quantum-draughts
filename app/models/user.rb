class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  skip_callback :validation, :before, :downcase_keys, if: :guest

  def to_s
    "#{id}: #{email} - #{displaying_name}"
  end
end
