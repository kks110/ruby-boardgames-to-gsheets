require 'json'
require 'google/apis/sheets_v4'
require 'googleauth'
require 'googleauth/stores/file_token_store'
require 'fileutils'

require './src/auth'
require './src/sheets'

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
    'Emma Player',
    'Kelvin Rating',
    'Emma Rating',
    'Notes'
  ]
])
