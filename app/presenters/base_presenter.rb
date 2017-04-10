class BasePresenter
  def self.map(objects)
    array = objects.map do |object|
      new(object).data
    end

    { data: array }
  end

  def initialize(object)
    @object = object
  end

  def as_json(options = {})
    {
      meta: meta,
      data: data
    }
  end

  def data
    {}
  end

  def meta
    {}
  end
end
