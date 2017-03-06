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

      @hash = {} of ::{{@type}} => ::Nil

      @by_status : ::Hash(::String, ::Array(::{{@type}}))?
      def by_status
        @by_status ||= {} of ::String => ::Array(::{{@type}})
      end

      def size
        @hash.size
      end

      def unsafe_at(index : ::Int)
        @hash.keys[index]
      end

      def <<(owner : ::{{@type}})
        @by_status = nil
        @hash[owner] = nil
      end

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
        name_string = name.stringify
      \%}

      def \{{name}}?
        @status.name == \{{name_string}}
      end

      def \{{name}}!(desc : String? = nil)
        status! \{{name_string}}, desc: desc
      end

      class Statuses
        def has_\{{name}}?
          has_status?(\{{name_string}})
        end

        @\{{name}} : ::Array(::{{@type}})?
        def \{{name}}
          by_status[\{{name_string}}]? || (by_status[\{{name_string}}] = self.select{|i| i.\{{name}}?})
        end

        def each_\{{name}}
          each do |i|
            yield i if i.\{{name}}?
          end
        end
      end
    end
  end
end
