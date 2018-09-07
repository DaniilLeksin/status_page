class DisplayHandler
  def shortLine(data, status=nil)
    if status.nil?
  	  p "#{data}"
    else
      p "[#{status.upcase}] #{data}"
    end
  end

  def tableView(data, indents, header)
    format = indents
    puts format % header
    data.each_with_index do |member, i|
      puts format % [ i+1, member[0], member[1], member[2], member[3], member[4] ]
    end
  end
end