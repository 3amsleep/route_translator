require "rails"

module Rails
  class Application
    if defined?(RoutesReloader)
      class RoutesReloader
        alias :reload_without_translator! :reload!
        def load_paths
          puts paths.inspect
          paths.each do |path| 
            if File.exists?(path)
              File.open(path) do |f|
                puts f.read
              end
            end
            load(path) 
          end
        end

        def reload!

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
