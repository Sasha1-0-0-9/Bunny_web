require "erb"
require './app/lib/logic'

class Bunny
  include Logic

  def self.call(environment)
    new(environment).response.finish
  end

  def initialize(environment)
    @rack = Rack::Request.new(environment)
    @food = 100
    @health = 100
    @happy = 100
    @cleanliness = 100
    @energy = 100
    @intelligence = 30
    $NEEDS = %w[food health happy cleanliness energy  water]
  end

  def response
    case @rack.path
    when '/'
      Rack::Response.new(render("start.html.erb"))

    when '/initialize'
      Rack::Response.new do |response|
        response.set_cookie('food', @food)
        response.set_cookie('health', @health)
        response.set_cookie('happy', @happy)
        response.set_cookie('cleanliness', @cleanliness)
        response.set_cookie('energy', @energy)
        response.set_cookie('intelligence', @intelligence)
        response.set_cookie('name', @rack.params['name'])
        response.redirect('/start')
      end

    when '/exit'
      Rack::Response.new('Game Over')
      Rack::Response.new(render("chill.html.erb"))

    when '/study'
      return Logic.study(@rack, 'intelligence') if @rack.params['intelligence']
      if get("intelligence") >= 100
        Rack::Response.new('Вы преисполнились в своем познании')
        Rack::Response.new(render("book.html.erb"))
      else
        Rack::Response.new(render("study.html.erb"))
      end

    when '/start'
      if get("health") <=0 or get("food") <= 0 or get("happy") <= 0 or get("cleanliness") <= 0 or get("energy") <= 0
        Rack::Response.new('Game Over')
        Rack::Response.new(render("gameover.html.erb"))
      else
        Rack::Response.new(render("index.html.erb"))
      end

    when '/change'
      return Logic.change_params(@rack, 'health') if @rack.params['health']
      return Logic.change_params(@rack, 'food')   if @rack.params['food']
      return Logic.change_params(@rack, 'energy')  if @rack.params['energy']
      return Logic.change_params(@rack, 'happy')  if @rack.params['happy']
      return Logic.change_params(@rack, 'health') if @rack.params['health']
      return Logic.change_params(@rack, 'cleanliness')  if @rack.params['cleanliness']
      return Logic.change_params(@rack, 'intelligence')  if @rack.params['intelligence']
    else
      Rack::Response.new('Not Found', 404)
    end
  end

  def render(template)
    path = File.expand_path("../pages/#{template}", __FILE__)
    ERB.new(File.read(path)).result(binding)
  end

  def name
    name = @rack.cookies['name'].delete(' ')
  end

  def get(attr)
    @rack.cookies["#{attr}"].to_i
  end
end
