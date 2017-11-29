module TimeTablesMatricesImporterHelper

  def self.import_reference_fleets
    TimeTablesMatrix.where.not(time_table_id: nil).each do |time_table_matrix|
      ImporterHelper.reference_fleet({time_table_date: time_table_matrix.time_table_date,file_name: time_table_matrix.time_table_date.strftime("%Y%m%d")})
    end
  end

   def self.import_executed_distribution_proposals
    TimeTablesMatrix.all.each do |time_table_matrix|
      ImporterHelper.executed_distribution_proposal({time_table_date: time_table_matrix.time_table_date,file_name: time_table_matrix.time_table_date.strftime("%Y%m%d")})
    end
  end

  def self.import_time_tables
    TimeTablesMatrix.where(time_table_id: nil).each do |time_table_matrix|
      ImporterHelper.time_table({time_table_date: time_table_matrix.time_table_date,file_name: time_table_matrix.time_table_date.strftime("%Y%m%d")})
    end
  end

  def self.import_commercial_matrices
    error = []
    TimeTablesMatrix.all.pluck(:commercial_matrix_date).uniq.each do |commercial_matrix_date|
      begin
        ImporterHelper.commercial_matrix({commercial_matrix_date: commercial_matrix_date,file_name: commercial_matrix_date.strftime("%Y%m%d")})
      rescue
        error << commercial_matrix_date.to_s
      end
    end
  end

  def self.import_dead_distance_matrices
    error = []
    TimeTablesMatrix.all.pluck(:dead_matrix_date).uniq.each do |dead_matrix_date|
      begin
        ImporterHelper.dead_matrix({dead_matrix_date: dead_matrix_date,file_name: dead_matrix_date.strftime("%Y%m%d")})
      rescue
        error << dead_matrix_date
        error
      end
    end
  end

end
