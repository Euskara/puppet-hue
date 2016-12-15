# <module_root>/lib/puppetx/hue/settings.rb
module PuppetX::Hue
  class Settings

    def self.ini_section(section, n=1)
      ini = []
      section.each do |k,v|
        if v.is_a?(Hash)
          ini << ("  " * n) + ("[" * n) + k + ("]" * n)
          ini << ini_section(v, n + 1)
        else
          ini << ("  " * (n + 1)) + "#{k}=#{v}"
        end
      end
      return ini.join("\n") + "\n"
    end
  end
end
