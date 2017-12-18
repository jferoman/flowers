class Color < ApplicationRecord
  require 'csv'
  
  validates_presence_of   :name
  validates_uniqueness_of :name

  has_many :demands
  has_many :varieties
  has_many :block_color_flowers
  has_many :color_submarkets

  class << self
    def import file_path
      attributes = %w(name)
      colors = []

      CSV.foreach(file_path, {
        encoding: "iso-8859-1:utf-8",
        headers: true,
        converters: :all,
        header_converters: lambda {|h| h.downcase.gsub(' ','_') }}) do |row|

        colors << row.to_h.slice(*attributes)
      end

      Color.bulk_insert values: colors
    end
  end
end
