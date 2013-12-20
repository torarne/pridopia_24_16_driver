#!/usr/bin/env ruby
# coding: UTF-8
# lib/led/matrix8x8.rb
#
# Adafruit's 8x8 LED matrix (http://adafruit.com/products/959)
#
# * prerequisite: http://www.skpang.co.uk/blog/archives/575
# 
# created on : 2012.09.12
# last update: 2013.06.28
# 
# by meinside@gmail.com
#
# tor@gisvold.co.uk - upate 31-aug-2013 for larger than 8*8 matrix 


# need 'i2c' gem installed
require "i2c/i2c"
require "i2c/backends/i2c-dev"

require_relative "../rpi"

# referenced: 
#   https://github.com/adafruit/Adafruit-Raspberry-Pi-Python-Code/blob/master/Adafruit_LEDBackpack/Adafruit_LEDBackpack.py
module Adafruit
  module LED
    class Matrix8x8
      # Registers
      HT16K33_REGISTER_DISPLAY_SETUP        = 0x80
      HT16K33_REGISTER_SYSTEM_SETUP         = 0x20
      HT16K33_REGISTER_DIMMING              = 0xE0

      # Blink rate
      HT16K33_BLINKRATE_OFF                 = 0x00
      HT16K33_BLINKRATE_2HZ                 = 0x01
      HT16K33_BLINKRATE_1HZ                 = 0x02
      HT16K33_BLINKRATE_HALFHZ              = 0x03

      MAX_COL = 24
      MAX_ROW = 16
      DATA_ADDRESSES = [0x70,0x71,0x72] # one row of 8*16 led's per data_address.
      
attr_accessor :matrixen_24_16; :Empty_matrix; :Matrix_8_8

	
	Empty_matrix = [ # X is the second parameter (inside the first array, y is the numebr of the arrays)
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

      Matrix_8_8 = [
      			[0,0,0,0,0,0,0,0],
      			[0,0,0,0,0,0,0,0],
	  			[0,0,0,0,0,0,0,0],
	  			[0,0,0,0,0,0,0,0],
	  			[0,0,0,0,0,0,0,0],
	  			[0,0,0,0,0,0,0,0],
	  			[0,0,0,0,0,0,0,0],
	  			[0,0,0,0,0,0,0,0]
      ]
 



      def initialize(device = RaspberryPi::i2c_device_path, options = {blink_rate: HT16K33_BLINKRATE_OFF, brightness: 01})
 
	  	@matrixen_24_16 = Empty_matrix
#	  	$offscreen_buffer_copy = Empty_matrix # No idea why I need this one - but without it everything stops working, now in root file
	  	@data_addresses = DATA_ADDRESSES
        if device.kind_of? String
          @device = ::I2C.create(device)
        else
          [ :read, :write ].each do |m|
            raise IncompatibleDeviceException, 
            "Missing #{m} method in device object." unless device.respond_to?(m)
          end
          @device = device
        end
        @data_addresses.each do |address| # Initialise each of the 8*16 LED stacks
        	@address = address

			# turn on oscillator
			@device.write(@address, HT16K33_REGISTER_SYSTEM_SETUP | 0x01, 0x00)

        end
			# set blink rate and brightness
			set_blink_rate(options[:blink_rate])
			set_brightness(options[:brightness])

        if block_given?
          yield self
        end
      end

# Start of module processing

      def set_blink_rate(rate)
      # Do not use this - as the zero point for the blinkrate depends on when it was set - they may be totally out of sync
        rate = HT16K33_BLINKRATE_OFF if rate > HT16K33_BLINKRATE_HALFHZ
        @data_addresses.each do |address|
        	@device.write(address, HT16K33_REGISTER_DISPLAY_SETUP | 0x01 | (rate << 1), 0x00)
        end
      end

      def set_brightness(brightness)
        brightness = 15 if brightness > 15
        @data_addresses.each do |address|
        	@device.write(address, HT16K33_REGISTER_DIMMING | brightness, 0x00)
        end
      end

      def clear # To be updated
        (0...MAX_ROW).each{|n| write(n, 0x00)}
      end

      def fill # To be updated
        (0...MAX_ROW).each{|n| write(n, 0xFF)}
      end





      def write(row, value)
      #
      # Needed a bit of a rewrite to find out which port to write to dependent on the row we write to
      #
      # It's COL that moves to next horisontal display
      #
      # a row goes across a multiple of 8 pixels
      #
      # if using a pridopia shield a row goes across the edge of 16 pixels, so we needed to rotate each display 90 degrees
      #  if we want to see this as 24 pixels wide
      #
      
      columns = MAX_COL / 8 # The number of 8 pixel displays horisontally
      	value1 = value & 0xFF
      if columns > 1 # If we have more than 1 display horisontally we need to write these to separate i2c addresses
      	value2 = (value/256) & 0xFF
      end
      if columns > 2 
      	value3 = (value/256/256) & 0xFF      
      end
      	@address = @data_addresses[0]
      	@address1 = @data_addresses[1]
      	@address2 = @data_addresses[2]
        if row < 8
        	@device.write(@address, row * 2, value1 & 0xFF) #First display really 
        	@device.write(@address1, row * 2, value2 & 0xFF) 
        	@device.write(@address2, row * 2, value3 & 0xFF)  
        else # we have a second row of 8*8 displays
        	@device.write(@address, (row - 8) * 2 + 1, value1 & 0xFF) # Second display
        	@device.write(@address1, (row - 8) * 2 + 1, value2 & 0xFF) 
        	@device.write(@address2, (row - 8) * 2 + 1, value3 & 0xFF) 
        end
      end


      
      def get_one_matrix(matrixen3, number)
      #
      # Slice out a 8*8 matrix from the larger 24*16 matrix.
      #
      matrix_8_8 = Matrix_8_8.clone     	
      x_offset = number.modulo(3) * 8
      	y_offset = 0
      	if number > 2 then
      		y_offset = 8
      	end
      	for x in 0..7
			for y in 0..7
     		 matrix_8_8[y][x]= matrixen3[y + y_offset][x + x_offset]
      		end
      	end
      	return matrix_8_8
      end

      
      def put_one_8_8_back(matrixen1,matrix_8_8,matrix_number)
      #
      # We have one big 24*16 matrix, and then one 8*8 matrix we need to replace in it's place in the big Matrix8x8
      #  this is not elegant - but should be understandable.
      #	
      #	It's all due to the need to rotate each 8*8 after they have been written.
      #
      # matrixen1 is the big matrix we want to replace a 8*8 slice of 
      # matrix_8_8 is the slice
      #
      	x_offset = matrix_number.modulo(3) * 8
      	y_offset = 0
      	if matrix_number > 2 then
      		y_offset = 8
      	end
      	for x in 0..7
			for y in 0..7
     		  matrixen1[y + y_offset][x + x_offset] = matrix_8_8[y][x]
      		end
      	end
		return matrixen1     
      end
      
           
      
      def rotate_array_elements(matrixen2)
      #
      # take out one 8*8 matrix (as we need to rotate them one by one)
      #  then rotate this array 90 degrees clockwise
      #  and put it back into it's place in the original 24*16 matrix.
      number = 0
      matrixen_8_8 = Matrix_8_8
         for number in 0..5 do
         	# Pull a 8*8 slice out of the much larger matrix
	      	matrixen_8_8 = get_one_matrix(matrixen2,number)
 	      	# Then rotate the 8*8
 	      	matrixen4 = matrixen_8_8.transpose 
 	      	# Then put it back where it came from
 	      	matrixenx = put_one_8_8_back(matrixen2,matrixen4,number)
	      end	
	      return matrixenx     
      end
      

      def write_array(arr)
#      byebug
		@matrixen_local = Empty_matrix.clone
      	@matrixen_local = rotate_array_elements(arr)
        @matrixen_local.each_with_index{|e, i|
          if e.kind_of? Array
#            raise "row #{i} has wrong number of elements: #{e.count}" if e.count != (MAX_COL)
            # XXX - reverse horizontally
#          puts "Write_array normal =>" + e.to_s
            e = e.reverse.map{|x| (x.to_i > 0 || x =~ /o/i) ? 1 : 0}.inject(0){|x, y| (x << 1) + y}
          end
          write(i, e.to_i)
        }
      end
      
      def empty()
		@matrixen_24_16 = Empty_matrix.clone	
      end
      
      def zero_matrix()
      	@matrixen_24_16 = Empty_matrix.clone	
      	write_array(Empty_matrix)
      end
      
      def write_pixel(value,x,y,write_to_screen)
      #
      # Write a pixel to a defined X and Y coordinate in the 24*16 matrix, and then send to device shield
      #
      # write_to_screen is true if a write to the screen should happen immediately after the pixel is set_backtrace
      #  if false it will not be written (to let us write multiple pixels before we update the display)
      #
#      	@matrixen_24_16[y][x] = value
      	$offscreen_buffer_copy[y][x] = value
      	# Then on to transformation and the actual write - which is extremely inefficient - need to rewrite.
      	# This is also where i had to introduce a global variable copy of the offscreen buffer, not quite sure why yet.
		for x in 0..23
			for y in 0..15
				@matrixen_24_16[y][x] = $offscreen_buffer_copy[y][x]
			end
		end
		if write_to_screen == true then
	  		write_array(@matrixen_24_16)
	  	end
      end

      def read(row)
      # Not finished and ready for prime time
      	data = 0x00
      	@data_addresses.each |address|
      		@address = address
	  		@device.read(@address, 2, row * 2).unpack("C")[0]	  		
      end
    end
  end
end

