require "rails"

module Rails
  class Application
    if defined?(RoutesReloader)
      class RoutesReloader
        alias :reload_without_translator! :reload!

        def reload!
          app = Rails.application
          fn = if (app.paths.config rescue nil)
            app.paths.config.routes
          else
            app.paths["config/routes"]
          end
          if fn
            File.open(fn.to_s) do |f|
              puts f.read
            end
          end
          result = reload_without_translator!

          route_sets.each do |routes|
            routes.default_locale = I18n.default_locale
            routes.translate_from_file
          end

          result
        end
      end
    else
      alias :reload_routes_without_translator! :reload_routes!
      def reload_routes!
        result = reload_routes_without_translator!

        self.routes.default_locale = I18n.default_locale
        self.routes.translate_from_file

        result
      end
    end
  end
end
