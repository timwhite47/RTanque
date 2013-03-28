class YoloBot < RTanque::Bot::Brain
  NAME = 'yolo_bot'
  include RTanque::Bot::BrainHelper

  def tick!
    ## main logic goes here
    # use self.sensors to detect things
    # use self.command to control tank
    # self.arena contains the dimensions of the arena
  end
end