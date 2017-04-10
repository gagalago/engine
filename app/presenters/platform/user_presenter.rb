class Platform::UserPresenter < BasePresenter
  def self.map(objects)
    array = objects.map do |object|
      new(object).data
    end

    {
      data: array,
      meta: {
        count: objects.size
      }
    }
  end

  def data
    {
      type: "user",
      id:   @object.public_id
    }
  end
end
