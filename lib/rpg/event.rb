module RPG
  
  class Event
    attr_reader :source
  
    @listeners = []
  
    def self.add_listener(listener)
      instance_variable_get(:@listeners) << listener
    end
  
    def self.remove_listener(listener)
      instance_variable_get(:@listeners).delete(listener)
    end
  
  
    def initialize(source)
      @source = source
      self.class.instance_variable_get(:@listeners) or self.class.instance_variable_set(:@listeners, [])
      notify_listeners
    end
    
    def notify_listeners
      listeners = self.class.instance_variable_get(:@listeners)
      listeners.each{|listener| listener.on_event(self) }
    end
  end

end