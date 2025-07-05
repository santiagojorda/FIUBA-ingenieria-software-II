module Cucumber
  module Web
    module URLs
      def url_for(*names)
        Capybara.app.url_for(*names)
      end
      alias url url_for

      def absolute_url_for(*names)
        "http://www.example.com#{Capybara.app.url_for(*names)}"
      end
      alias absolute_url absolute_url_for
    end
  end
end

World(Cucumber::Web::URLs)
