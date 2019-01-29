require 'rtlize/helpers'
require 'rtlize/rtl_processor'

module Rtlize
  class Railtie < ::Rails::Railtie
    config.rtlize = ActiveSupport::OrderedOptions.new
    config.rtlize.rtl_selector = Rtlize.rtl_selector
    config.rtlize.rtl_locales  = Rtlize.rtl_locales

    config.assets.configure do |env|
      # Support Sprockets 3, 4
      if env.respond_to?(:register_transformer)
        env.register_mime_type 'text/css', extensions: ['.css'], charset: :css
        env.register_postprocessor 'text/css', Rtlize::RtlProcessor
      end

      # Support Sprockets 2
      if env.respond_to?(:register_engine)
        args = ['.css', Rtlize::RtlProcessor]
        args << { mime_type: 'text/css', silence_deprecation: true } if Sprockets::VERSION.start_with?("3")
        env.register_engine(*args)
      end

      Rtlize.rtl_selector = config.rtlize.rtl_selector
      Rtlize.rtl_locales  = config.rtlize.rtl_locales
    end
  end
end
