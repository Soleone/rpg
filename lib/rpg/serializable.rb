module Serializable
  
  module ClassMethods
    def from_yaml(filename, label = nil)
      # TODO: caching
      models = YAML.load_file(filename)
      models_array = models.map do |title, attributes|
        [title, self.from_hash(attributes)]
      end
      models = Hash[models_array]
      label ? models[label.to_s] : models
    end
  
    def from_hash(attributes)
      self.new do |model|
        attributes.each do |name, value|
          model.send("#{name}=", value)
        end
      end
    end
  end
  
  def self.included(base)
    base.extend(ClassMethods)
  end
end