class Kirk::Client
  class InvalidRequestError < ArgumentError ; end

  class Request
    attr_reader :group

    def initialize(group, method = nil, url = nil, handler = nil, body = nil, headers = {})
      @group   = group
      method(method)
      url(url)
      handler(handler)
      body(body)
      headers(headers)

      yield(self) if block_given?
    end

    %w/url headers handler body/.each do |method|
      class_eval <<-RUBY
        def #{method}(#{method} = nil)
          @#{method} = #{method} if #{method}
          @#{method}
        end
      RUBY
    end

    def method(method = nil)
      @method = method.to_s.upcase if method
      @method
    end

    def validate!
      unless method
        raise InvalidRequestError, "Must specify an HTTP method for the request"
      end

      unless url
        raise InvalidRequestError, "Must specify a URL for the request"
      end
    end
  end
end
