#!/usr/bin/env ruby
# coding: UTF-8

# test/led/matrix8x8.rb
#
# test script for
# Adafruit's 8x8 LED matrix (http://adafruit.com/products/959)
# 
# created on : 2013.06.27
# last update: 2013.06.28
# 
# by meinside@gmail.com

require 'byebug'
require 'matrix'
require_relative "./matrix8x8"
require_relative "./font7_5"

if __FILE__ == $0

puts "Start"

  Adafruit::LED::Matrix8x8.new{|led|
    # smile!
#    puts "start write_array"
#    led.write_array(
    test = [ # Nb - for each 8*8 matrix of LED's x and y is flipped 90 degrees counter clockwise


      [1, 1, 1, 1, 1, 1, 1, 1,1, 1, 1, 1, 1, 1, 1, 1,1, 1, 1, 1, 1, 1, 1, 1], 
      [0, 0, 0, 0, 0, 0, 1, 1,1, 0, 0, 0, 0, 0, 1, 1,1, 0, 0, 0, 0, 0, 0, 1],
      [0, 0, 0, 0, 0, 1, 1, 1,1, 0, 0, 0, 0, 1, 1, 1,1, 0, 0, 0, 0, 0, 0, 1],
      [0, 0, 0, 0, 1, 1, 1, 1,1, 0, 0, 0, 1, 1, 1, 1,1, 0, 0, 0, 0, 0, 0, 1],
      [0, 0, 0, 1, 1, 1, 1, 1,1, 0, 0, 1, 1, 1, 1, 1,1, 0, 0, 0, 0, 0, 0, 1],
      [0, 0, 1, 1, 1, 1, 1, 1,1, 0, 1, 1, 1, 1, 1, 1,1, 0, 0, 0, 0, 0, 0, 1],
      [0, 1, 1, 1, 1, 1, 1, 1,1, 1, 1, 1, 1, 1, 1, 1,1, 0, 0, 0, 0, 0, 0, 1],
      [1, 1, 1, 1, 1, 1, 1, 1,1, 1, 1, 1, 1, 1, 1, 1,1, 0, 0, 0, 0, 0, 0, 1],
      
      [0, 0, 0, 0, 0, 0, 0, 1,1, 0, 0, 0, 0, 0, 0, 1,1, 0, 0, 0, 0, 0, 0, 1], 
      [0, 0, 0, 0, 0, 0, 1, 1,1, 0, 0, 0, 0, 0, 1, 1,1, 0, 0, 0, 0, 0, 0, 1],
      [0, 0, 0, 0, 0, 1, 1, 1,1, 0, 0, 0, 0, 1, 1, 1,1, 0, 0, 0, 0, 0, 0, 1],
      [0, 0, 0, 0, 1, 1, 1, 1,1, 0, 0, 0, 1, 1, 1, 1,1, 0, 0, 0, 0, 0, 0, 1],
      [0, 0, 0, 1, 1, 1, 1, 1,1, 0, 0, 1, 1, 1, 1, 1,1, 0, 0, 0, 0, 0, 0, 1],
      [0, 0, 1, 1, 1, 1, 1, 1,1, 0, 1, 1, 1, 1, 1, 1,1, 0, 0, 0, 0, 0, 0, 1],
      [0, 0, 0, 0, 0, 0, 0, 0,1, 1, 1, 1, 1, 1, 1, 1,1, 0, 0, 0, 0, 0, 0, 1],
      [1, 1, 1, 1, 1, 1, 1, 1,1, 1, 1, 1, 1, 1, 1, 1,1, 0, 0, 0, 0, 0, 0, 1]
      
      
# - following after mapping reversal e = e.reverse.map{|x| (x.to_i > 0 || x =~ /o/i) ? 1 : 0}.inject(0){|x, y| (x << 1) + y}
# 128 => 16448 => 0x4040 = 01000000 01000000
# 192 => 24672 => 0x6060 = 01100000 01100000
# 224 => 28784 => 0x7070 = 01110000 01110000
#


# m.reverse.transpose for each of the 8 by 8 matrixes
     
    ]

	Empty_matrix = [ # X is the second parameter (inside the first rarray, y is the number of the arrays)
	  [0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0], 
      [0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0],
      
      [0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0], 
      [0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0]

	]


	$offscreen_buffer_copy = Empty_matrix.clone # No idea why I need this one - but without it everything stops working, 

    led.clear
    led.zero_matrix

	def draw_linje(linje,linje_nr)
		x_offset = 0
		y_offset = linje_nr * 8
		 for char_nr in 0..3 do
		 	draw_tegn_offset(linje[char_nr],x_offset,y_offset)
		 	x_offset = x_offset + 6
		 end
	end

	def draw_tegn_offset(tegn,x_offset,y_offset)
#		for tegn in '!'..'z' do
			matrix_tegn = draw_tegn(tegn)
			for x in 0..7
					for y in 0..7 
						$led.write_pixel(matrix_tegn[y][x],x + x_offset,y + y_offset,false)
					end
				end
			$led.write_pixel(matrix_tegn[y][x],x,y,true)
		end




 $led = led	


}	


draw_linje("test",0)
draw_linje("four",1)
draw_linje("date",0)
draw_linje("time",1)
flip_pixel = 0
while true do
begin
        $time = Time.now
        timestring = $time.strftime("%H%M")
        datestring = $time.strftime("%d%m")
        draw_linje(datestring,0)
        draw_linje(timestring,1)
		$led.write_pixel(flip_pixel,23,15,true)
        sleep(10)
		if flip_pixel == 0 then
			flip_pixel = 1
		else
			flip_pixel = 0
		end
end
end


end

	