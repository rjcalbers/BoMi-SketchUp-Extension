unless file_loaded?(__FILE__)
  module DynamicScriptMenu
    SCRIPTS_DIR = File.join(File.dirname(__FILE__), 'MyScripts').freeze

    def self.populate_menu(menu)
      # NO CLEAR - just add (reload recreates fresh)
      return unless Dir.exist?(SCRIPTS_DIR)

      Dir.chdir(SCRIPTS_DIR) do
        script_files = Dir.glob('**/*.rb').sort.reject { |f| f == 'dynamic_menu_loader.rb' }

        script_files.each do |script_path|
          script_name = File.basename(script_path, '.rb').tr('_', ' ').split.map(&:capitalize).join(' ')
          full_path = File.join(SCRIPTS_DIR, script_path)

          menu.add_item(script_name) do
            begin
              load(full_path)
            rescue => e
              UI.messagebox("Error loading #{script_name}:\n#{e.message}")
            end
          end
        end
      end

      menu.add_separator
      menu.add_item('Refresh') { refresh_menu }
    end

    def self.refresh_menu
      plugins_menu = UI.menu('Extensions')
      # Destroy & recreate submenu (clears contents)
      plugins_menu.remove_item('My Scripts') rescue nil
      my_menu = plugins_menu.add_submenu('My Scripts')
      populate_menu(my_menu)
    end

    # Initial setup
    plugins_menu = UI.menu('Extensions')
    my_menu = plugins_menu.find_item('My Scripts') rescue plugins_menu.add_submenu('My Scripts')
    populate_menu(my_menu)
  end

  file_loaded(__FILE__)
end
