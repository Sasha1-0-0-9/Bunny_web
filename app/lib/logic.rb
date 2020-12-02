module Logic
  def self.change_params(rack, name)
    Rack::Response.new do |response|
      response.set_cookie(name, rack.cookies["#{name}"].to_i + 10) if rack.cookies["#{name}"].to_i < 100
      need = ($NEEDS - [name]).sample
      response.set_cookie(need, rack.cookies["#{need}"].to_i - 10)
      response.redirect('/start')
    end
  end

  def self.study(rack, name)
    Rack::Response.new do |responses|
      responses.set_cookie(name, rack.cookies["#{name}"].to_i + rand(-5..20))
      responses.redirect('/study')
    end
  end
end
