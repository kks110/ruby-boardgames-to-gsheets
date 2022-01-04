class Sheets
  attr_accessor :sheets_id, :service

  def initialize(service)
    @service = service
    @sheets_id = load_sheets_id
  end

  def create
    return unless sheets_id == ''

    spreadsheet = {
      properties: {
        title: 'Boardgames'
      }
    }
    spreadsheet = service.create_spreadsheet(spreadsheet, fields: 'spreadsheetId')

    File.open('data.json', 'w') do |f|
      f.write(
        {
          "sheet_id" => spreadsheet.spreadsheet_id
        }.to_json
      )
    end
    @sheets_id = spreadsheet.spreadsheet_id
  end

  def update_values(range_name, values)
    value_range_object = Google::Apis::SheetsV4::ValueRange.new(range: range_name, values: values)
    result = service.update_spreadsheet_value(
      sheets_id,
      range_name,
      value_range_object,
      value_input_option: 'USER_ENTERED'
    )
    result
  end

  def load_sheets_id
    return '' unless File.file?('data.json')

    file = File.read('data.json')
    data_hash = JSON.parse(file)
    @sheets_id = data_hash['sheet_id']
  end
end
