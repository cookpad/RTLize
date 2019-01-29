require 'rtlize/helpers'
require 'rtlize/rtl_processor'

module Rtlize
  class Railtie < ::Rails::Application
    config.rtlize = ActiveSupport::OrderedOptions.new
    config.rtlize.rtl_selector = Rtlize.rtl_selector
    config.rtlize.rtl_locales  = Rtlize.rtl_locales
    
    config.assets.configure do |assets|
      # Support Sprockets 3,4
      if assets.respond_to?(:register_transformer)
        assets.register_mime_type 'text/css', extensions: ['.css'], charset: :css
        assets.register_postprocessor 'text/css', Rtlize::RtlProcessor
      end

      # Support Sprockets 2
      if assets.respond_to?(:register_engine)
        args = ['.css', Rtlize::RtlProcessor]
        args << { mime_type: 'text/css', silence_deprecation: true } if Sprockets::VERSION.start_with?("3")
        assets.register_engine(*args)
      end

      Rtlize.rtl_selector = config.rtlize.rtl_selector
      Rtlize.rtl_locales  = config.rtlize.rtl_locales
    end
  end
end
