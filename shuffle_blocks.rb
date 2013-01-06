require 'rubygems'
require 'sinatra'
require 'haml'

BlueStrings = %w(blue sad sky cold guitar tiffanys ice end )
RedStrings = %w(red pink orange pinkish salmon skin love heat embarrasment rose warm end)
LightStrings = %w(sun stars bright yellow shine happy excite bounce air sparkle)

make_bluer = lambda{|lighter_color|
  bluer_color = lighter_color + "_" + BlueStrings.sample
  puts "bluer color: #{bluer_color}"
  bluer_color
}
make_redder = lambda{|lighter_color|
  redr_color = lighter_color + "_" + RedStrings.sample
  puts "redder color: #{redr_color}"
  redr_color
}

class ShuffledColors
  def lighten_color(color, &block)
    # puts "in lighten_color with #{color}"
    color = color + "_" + LightStrings.sample
    newcolor = block.call(color)
    self.shuffled_colors << newcolor
    if newcolor =~ /end/
      return shuffled_colors
    else
      lighten_color(newcolor, &block) unless newcolor =~ /end/
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
