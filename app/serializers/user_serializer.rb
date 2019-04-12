# frozen_string_literal: true

class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :displaying_name

end
