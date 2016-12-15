module Puppet::Parser::Functions
  newfunction(:ini_settings, :type => :rvalue, :doc => <<-EOS
Creates a hue.ini sections and subsections from a hash:
    $settings = {  section1 => {
        setting1 => val1
      },
      section2 => {
        setting2 => val2,
        subsection1 => {
          setting3 => val3
        }
      }
    }

  [section1]
    setting1=val1
  [section2]
    setting2=val2
    [[subsection1]]
      setting3=val3

EOS
  ) do |arguments|
    require "puppetx/hue/settings"
    raise(Puppet::ParseError, "ini_settings(): Wrong number of arguments") if arguments.size != 1
    raise(Puppet::ParseError, "ini_settings(): Not an hash") if !arguments[0].is_a?(Hash)

    return  PuppetX::Hue::Settings.ini_section(arguments[0])
  end
end
