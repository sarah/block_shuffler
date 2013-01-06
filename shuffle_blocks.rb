require 'rubygems'
require 'sinatra'
require 'haml'

BlueStrings = %w(blue sad sky cold guitar tiffanys ice end )
RedStrings = %w(red pink orange pinkish salmon skin love heat embarrasment rose warm end)
LightStrings = %w(sun stars bright yellow shine happy excite bounce air sparkle)

make_bluer = lambda{|lighter_color|
  lighter_color + "_" + BlueStrings.sample # make bluer
}
make_redder = lambda{|lighter_color|
  lighter_color + "_" + RedStrings.sample # make redder
}

module ColorMods
  def self.make_bluer
    lambda{|lighter_color|
      lighter_color + "_" + BlueStrings.sample # make bluer
    }
  end

  def self.make_redder
    lambda{|lighter_color|
      lighter_color + "_" + RedStrings.sample # make redder
    }
  end
end

class ShuffledColors
  def lighten_color(color, &color_modifier_block)
    color = (initial_color?) ? color : lighten(color)
    altered_color = color_modifier_block.call(color)
    self.shuffled_colors << [color, altered_color]
    return shuffled_colors if final_color?(altered_color)

    lighten_color(altered_color, &color_modifier_block)
  end

  attr_accessor :shuffled_colors
  def initialize
    @shuffled_colors = []
  end
  private
  def initial_color?
    shuffled_colors.empty?
  end
  def lighten(color)
    color + "_" + LightStrings.sample
  end
  def final_color?(color)
    color =~ /end/
  end
end

get '/' do
  shuffler = ShuffledColors.new
  colors = shuffler.lighten_color("blue", &make_bluer)

  haml :index, :locals => {colors: colors}
end
