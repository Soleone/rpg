module RPG
  
  class Event
    attr_reader :type, :listeners
    
    @@all = []

    def self.all(type = nil)
      type ? @@all.select{|event| event.type == type.to_sym } : @@all
    end
    
    def self.fire(*args)
      event = self.new(*args)
      event.notify_listeners
      @@all << event
      event
    end
  
    def initialize(type, *listeners)
      @type = type
      @listeners = [listeners].flatten
    end
    
    
    def notify_listeners
      listeners.each do |listener|
        begin
          listener.send("on_#{type}", self)
        rescue NoMethodError
          listener.on_event(self)
        end
      end
    end
  end

end