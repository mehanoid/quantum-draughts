# frozen_string_literal: true

concern :SerializationHelper do
  def serialize(model, **options)
    self.class.serialize(model, **options)
  end

  class_methods do
    def serialize(model, **options)
      ActiveModelSerializers::SerializableResource.new(model, **options).as_json
    end
  end
end
