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

class ShuffledColors
  def lighten_color(color, &block)
    pair = []
    # if shuffled_colors.empty?
      # pair << color
      # pair << block.call(color)
    # end

    pair << color if shuffled_colors.empty?# add initial color
    color = color + "_" + LightStrings.sample # lighten color
    pair << color unless shuffled_colors.empty?# add initial color
    newcolor = block.call(color) # mod color

    pair << newcolor # add modded color

    self.shuffled_colors << pair
    if newcolor =~ /end/
      return shuffled_colors
    else
      lighten_color(newcolor, &block)
    end
  end

  attr_accessor :shuffled_colors
  def initialize
    @shuffled_colors = []
  end
end

get '/' do
  shuffler = ShuffledColors.new
  colors = shuffler.lighten_color("blue", &make_bluer)

  haml :index, :locals => {colors: colors}
end
