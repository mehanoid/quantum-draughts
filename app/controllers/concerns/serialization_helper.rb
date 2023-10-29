# frozen_string_literal: true

concern :SerializationHelper do
  def serialize(model, **)
    self.class.serialize(model, **)
  end

  class_methods do
    def serialize(model, **)
      ActiveModelSerializers::SerializableResource.new(model, **).as_json
    end
  end
end
