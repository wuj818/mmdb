require 'hirb'

Hirb.enable

old_print = Pry.config.print
Pry.config.print = proc do |*args|
  Hirb::View.view_or_page_output(args[1]) || old_print.call(*args)
end

def formatted_env
  color = case Rails.env
          when 'production' then :red
          when 'staging'    then :yellow
          when 'test'       then :blue
          else                   :green
          end

  Pry::Helpers::Text.send(color, Rails.env)
end

def app_name
  Rails.application.class.parent_name.underscore.dasherize
end

Pry.config.prompt = proc do |obj, nest_level, _|
  "[#{app_name}][#{formatted_env}] #{obj}:#{nest_level}> "
end
