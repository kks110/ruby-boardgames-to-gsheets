require 'json'
require 'google/apis/sheets_v4'
require 'googleauth'
require 'googleauth/stores/file_token_store'
require 'fileutils'

require './src/auth'
require './src/sheets'
require './src/games'

APPLICATION_NAME = 'Boardgames'.freeze
service = Google::Apis::SheetsV4::SheetsService.new
service.client_options.application_name = APPLICATION_NAME
service.authorization = Auth.authorize

sheet = Sheets.new(service)
sheet.create
sheet.update_values('A1:M1', [
  [
    'Own',
    'Title',
    'Expansion',
    'Min Players',
    'Max Players',
    'Min Play Time',
    'Max Play Time',
    'Weight',
    'Kelvin Played',
    'Emma Played',
    'Kelvin Rating',
    'Emma Rating',
    'Notes'
  ]
])

games = Games.new
game_array = []
if games.validate
  games.game_list.each do |game|
    game_array << [
      'true',
      game['title'],
      game['expansion'].nil? ? 'false' : 'true',
      game['players'][0],
      game['players'][1],
      game['playTime'][0],
      game['playTime'][1],
      game['weight'],
      'false',
      'false',
      0,
      0
    ]
  end
end

row = 2
game_array.each do |game_data|
  sheet.update_values("A#{row}:L#{row}", [
    game_data
  ])
  row += 1
end
