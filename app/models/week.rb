class Week < ApplicationRecord
  require 'csv'
  validates_presence_of :initial_day, :week
  validates :initial_day, uniqueness: { scope: :week }

  has_many :submarket_weeks
  has_many :cuttings
  has_many :demands
  has_many :sowing_details
  has_many :productions
  has_many :bed_productions
  has_many :sowing_details
  has_many :sowing_solutions

  class << self
    def import file_path
      attributes = %w(initial_day week)
      weeks = []

      CSV.foreach(file_path, {
        encoding: "iso-8859-1:utf-8",
        headers: true,
        converters: :all,
        header_converters: lambda {|h| h.downcase.gsub(' ','_') }}) do |row|

        weeks << row.to_h.slice(*attributes)
      end

      Week.bulk_insert values: weeks
    end
  end

  ##
  #
  # Devuelve el objeto week que sucede dentro de las semanas indicadas.
  # Parametro weeks: numero de semanas.
  #
  ##
  def next_week_in weeks
    Week.find_by(initial_day: initial_day+( weeks * 7.days))
  end

end
