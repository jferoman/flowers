class ProductivityCurve < ApplicationRecord

  validates_presence_of :week_number, :cost, :production, :cut, :farm_id, :variety_id
  validates_numericality_of :cost, :allow_nil => false
  validates_numericality_of :production, :cut, :allow_nil => false
  validates :week_number, uniqueness: { scope: [:farm_id, :variety_id] }

  belongs_to :farm
  belongs_to :variety

  delegate :name, to: :farm, prefix: true
  delegate :name, to: :variety, prefix: true

  class << self 
		def import file_path, company_id, permission_farm_id = nil
		  production_curves = []
		  errors = []
		  attributes = %w(variety_name week_number cost production farm_name cut)
		  varieties = Variety.all.pluck(:name,:id).to_h
      company = Company.find(company_id)
		  farms = company.farms.all.pluck(:name,:id).to_h
     
		  productivity_curves = []

	    CSV.foreach(file_path, {
	      encoding: "iso-8859-1:utf-8",
	      headers: true,
	      converters: :all,
	      header_converters: lambda { |h| I18n.transliterate(h.downcase.gsub(' ','_'))}} ) do |row|
	    	row = row.to_h.slice(*attributes)

        farm_id = farms[row['farm_name']]
        variety_id = varieties[row['variety_name']]
        
        errors << row.merge({'No existe finca:' =>  row['farm_name']}) if farm_id.nil?
        errors << row.merge({'No existe Variedad:' =>  row['variety_name']}) if variety_id.nil?
        
        relations = {
        	farm_id: farm_id,
        	variety_id: variety_id
        }
        production_curves << row.except("farm_name","variety_name").merge(relations)
	    end
      
      if errors.empty?
        ProductivityCurve.bulk_insert values: production_curves
      else
        csv_with_errors errors
      end
		end

    def csv_with_errors erros
      file_path = "db/tmp_files/errores_cortes.csv"
      CSV.open(file_path, "wb") do |csv|
        erros.each do |error|
          csv << error
        end
      end
      file_path
    end
	end
end
