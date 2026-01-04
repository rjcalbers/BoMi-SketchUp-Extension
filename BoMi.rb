# MyRunner.rb
require 'sketchup.rb'
require 'extensions.rb'

module MyCompany
  module BoMi

    EXTENSION_NAME = 'BoMi'.freeze
    EXTENSION_ID   = 'BoMi'.freeze

    unless defined?(EXTENSION)
      loader_path = File.join(__dir__, 'BoMi', 'main')

      EXTENSION = SketchupExtension.new(EXTENSION_NAME, loader_path)
      EXTENSION.description = 'Adds a menu item that runs a custom Ruby script.'
      EXTENSION.version     = '1.0.0'
      EXTENSION.creator     = 'BoMi'

      Sketchup.register_extension(EXTENSION, true)
    end

  end
end

