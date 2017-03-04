struct Sf::Status
  getter name : ::String
  getter description : ::String?

  def initialize(@name, desc = nil)
    @description = desc
  end

  def set?
    !@name.empty
  end
end
