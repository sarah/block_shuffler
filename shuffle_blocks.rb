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
    color_pair = []


    color_pair << color if initial_run?
    color = lighten(color)

    color_pair << color unless initial_run?
    altered_color = block.call(color) # mod color

    color_pair << altered_color # add modded color
    self.shuffled_colors << color_pair

    return shuffled_colors if final?(altered_color)
    lighten_color(altered_color, &block)
  end

  attr_accessor :shuffled_colors
  def initialize
    @shuffled_colors = []
  end
  private
  def initial_run?
    shuffled_colors.empty?
  end
  def lighten(color)
    color + "_" + LightStrings.sample
  end
  def final?(color)
    color =~ /end/
  end
end

get '/' do
  shuffler = ShuffledColors.new
  colors = shuffler.lighten_color("blue", &make_bluer)

  haml :index, :locals => {colors: colors}
end
