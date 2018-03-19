require 'smarter_csv'
class FileProcessor

  def initialize(filename)
    @filename = filename
    normalize_original_file
    @data = process_csv
  end

  def normalize_original_file
    return false unless File.exists? "data/#{@filename}"
    data = []
    output = File.open(cleaned_csv_path, "w")

    File.open("data/#{@filename}", "r") do |f|
      f.each_line do |line|
        data << strip_csv_empty_column(line)
      end
    end
    output << data.join
    output.close
    data
  end

  def process_csv
    processed_row = []
    SmarterCSV.process(cleaned_csv_path) do |transactions|
      processed_row << transactions.each do |tsx|
        tsx[:date] = date_transform(tsx[:date])
        tsx[:description] = description_transform(tsx[:description])
        tsx[:credit] = description_dollar_value(tsx[:credit]) if tsx[:credit]
        tsx[:debit] = description_dollar_value(tsx[:debit]) if tsx[:debit]
        tsx[:balance] = description_dollar_value(tsx[:balance])

        tsx
      end
    end
    processed_row.flatten
  end

  private
  def strip_csv_empty_column(line)
    line.gsub(",,,,","")
  end

  def cleaned_csv_path
    "data/cleaned_data.csv"
  end

  def date_transform(date)
    Date.parse(date).to_s
  end

  def description_transform(desc)
    desc = desc.gsub('Click for details', '').downcase
    if desc.include? ('interest')
      'interest'
    elsif desc.include?('direct')
      'direct deposit'
    elsif desc.include?('deposit') && !desc.include?('direct')
      'extra deposit'
    else
      'unknown'
    end
  end

  def description_dollar_value(value)
    value.gsub('$', '').gsub(',', '_').to_f unless value.nil?
  end
end
