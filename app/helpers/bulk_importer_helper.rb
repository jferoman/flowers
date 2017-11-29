module BulkImporterHelper

  def self.import_reference_fleets
    TimeTable.all.each do |time_table|
      ImporterHelper.reference_fleet({time_table_date: time_table.time_table_date,file_name: time_table.time_table_date.strftime("%Y%m%d")}) rescue nil
    end
  end

  def self.import_executed_bus_service_assignations
    TimeTable.all.each do |time_table|
      next if time_table.executed_time_table? != "NO" or time_table.description != "Original TM"
      ImporterHelper.executed_bus_service_assignations({time_table_date: time_table.time_table_date,file_name: time_table.time_table_date.strftime("%Y%m%d")}) rescue nil
    end
  end

  def self.import_commercial_matrices
    error = []
    TimeTable.all.pluck(:commercial_matrix_date).uniq.each do |commercial_matrix_date|
      begin
        ImporterHelper.commercial_matrix({commercial_matrix_date: commercial_matrix_date,file_name: commercial_matrix_date.strftime("%Y%m%d")})
      rescue
        error << commercial_matrix_date.to_s
      end
    end
  end

  def self.import_dead_distance_matrices
    error = []
    TimeTable.all.pluck(:dead_matrix_date).uniq.each do |dead_matrix_date|
      begin
        ImporterHelper.dead_matrix({dead_matrix_date: dead_matrix_date,file_name: dead_matrix_date.strftime("%Y%m%d")})
      rescue
        error << dead_matrix_date
        error
      end
    end
  end
end
