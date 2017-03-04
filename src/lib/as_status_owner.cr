module Sf::AsStatusOwner
  macro extended
    class RaisableStatus < ::Exception
      getter owner : ::{{@type}}
      getter status : ::Sf::Status

      def initialize(@owner, @status)
      end
    end

    property status : ::Sf::Status = ::Sf::Status.new("")

    class Statuses < ::Array(::{{@type}})
      def continue
        begin
          yield
        rescue ex : ::{{@type}}::RaisableStatus
          ex.owner.status = ex.status
          self << ex.owner
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

      def \{{name}}!(desc : String? = nil)
        raise ::{{@type}}::RaisableStatus.new(
          self,
          ::Sf::Status.new(\{{name.stringify}}, desc: desc)
        )
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
