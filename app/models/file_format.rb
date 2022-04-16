# frozen_string_literal: true

require 'zip'
require 'csv'

class FileFormat < ApplicationRecord
  class << self
    def unzip_file(file)
      csv_file = Tempfile.new(['extracted', '.csv'], 'tmp')
      Zip.on_exists_proc = true
      Zip.continue_on_exists_proc = true
      Zip::File.open(file.path) do |zip_file|
        zip_file.each do |entry|
          entry.extract(csv_file)
        end
      end
      csv_file
    end

    def extract_data(csv_file)
      CSV.parse(File.read(csv_file)).last
    end
  end
end
