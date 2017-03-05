module Sf::AsStatusOwner
  macro extended
    class RaisableStatus < ::Exception
      getter owner : ::{{@type}}
      getter status : ::Sf::Status

      def initialize(@owner, @status)
      end
    end

    property status : ::Sf::Status = ::Sf::Status.new("")

    def status(name : String | Symbol, desc : String? = nil)
      @status = ::Sf::Status.new(name, desc: desc)
      self
    end

    def status!(name : String | Symbol, desc : String? = nil)
      raise ::{{@type}}::RaisableStatus.new(
        self,
        ::Sf::Status.new(name, desc: desc)
      )
    end

    class Statuses
      include ::Indexable(::{{@type}})

      @array = [] of ::{{@type}}

      def size
        @array.size
      end

      def unsafe_at(index : ::Int)
        @array.unsafe_at(index)
      end

      def append(owner : ::{{@type}}, name : String | Symbol, desc : String? = nil)
        owner.status name, desc: desc
        @array << owner
      end

      def <<(owner : ::{{@type}})
        @array << owner
      end

      def continue
        begin
          yield
        rescue ex : ::{{@type}}::RaisableStatus
          ex.owner.status = ex.status
          @array << ex.owner
        end
      end

      def has_status?(name : String | Symbol)
        name = name.to_s
        any?{|i| i.status.name == name}
      end
    end

    macro status(name)
      \{%
        name = name.id
      \%}

      def \{{name}}?
        @status.name == \{{name.stringify}}
      end

      def \{{name}}!(desc : String? = nil)
        status! \{{name.stringify}}, desc: desc
      end

      class Statuses
        def has_\{{name}}?
          has_status?(\{{name.stringify}})
        end

        @\{{name}} : ::Array(::{{@type}})?
        def \{{name}}
          @\{{name}} ||= self.select{|i| i.status.name == \{{name.stringify}}}
        end
      end
    end
  end
end
