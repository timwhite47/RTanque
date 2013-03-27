class MyDeadlyBot < RTanque::Bot::Brain
  NAME = 'my_deadly_bot'
  include RTanque::Bot::BrainHelper

  def tick!
  	
  	@radar_degree ||= 0
  	@delta ||= 0
  	command.speed = 5

  	if @current_enemy
  		@radar_degree = @current_enemy[:bot].heading.to_degrees
  		command.turret_heading = @current_enemy[:bot].heading
  		command.fire if locked_and_loaded?
  		if (sensors.ticks - @current_enemy[:found_on]) > 25
	  		@current_enemy = nil 
	  		@radar_degree = 0
	  	end
  	else
  		if @radar_degree > 360
  			@radar_degree = 0
  		else
  			@radar_degree += 5
  		end
  		command.radar_heading = RTanque::Heading.new_from_degrees (@radar_degree || 0)
	end
	
	
	if sensors.radar.count > 0 and !@current_enemy
		@current_enemy = {:bot => sensors.radar.first, :found_on => sensors.ticks}
		change_direction
		# puts "my heading: #{sensors.heading.inspect}"
		# puts "their heading: #{@current_enemy[:bot].heading.inspect}"
	elsif sensors.radar.count > 0 and sensors.radar.first.name == @current_enemy[:bot].name
		@delta = @current_enemy[:bot].heading.delta(sensors.radar.first.heading)
		change_direction
	end	
  	
    ## main logic goes here
    # use self.sensors to detect thiawngs
    # use self.command to control tank
    # self.arena contains the dimensions of the arena
  end

  def locked_and_loaded?
  	if @delta and @current_enemy
  		(@delta.abs < 0.01 and @current_enemy[:bot].distance < 500)
  	else
  		false
  	end
  end

  def change_direction
  	if @current_enemy[:bot].distance > 500
  		command.heading = @current_enemy[:bot].heading
  	else
  		command.heading = command.heading = @current_enemy[:bot].heading.delta(sensors.heading)
  	end
  end
end