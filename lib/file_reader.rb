class FileReader

  def initialize(filename)
    @filename = filename
    @data = read
  end

  def read
    return false unless File.exists? "data/#{@filename}"
    data = []

    File.open("data/#{@filename}", "r") do |f|
      f.each_line do |line|
        data << line
      end
    end
    data
  end
end
