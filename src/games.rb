class Games
  def initialize
    @game_list = load_games
  end

  attr_reader :game_list

  def validate
    @game_list.each do |game|
      if game['title'].nil?
        puts "Found a missing title"
        puts game
        return false
      end

      if game['players'].length != 2
        puts "Players not long enough"
        puts game
        return false
      end

      if game['playTime'].length != 2
        puts "Playtime not long enough"
        puts game
        return false
      end
    end
    true
  end

  def load_games
    file = File.read('games.json')
    JSON.parse(file)
  end
end
