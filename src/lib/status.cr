struct Sf::Status
  getter name : ::String
  getter description : ::String?

  def initialize(name : String | Symbol, desc = nil)
    @name = name.to_s
    @description = desc
  end

  def set?
    !@name.empty
  end
end
