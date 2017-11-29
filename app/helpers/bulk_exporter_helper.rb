module BulkExporterHelper

  def self.export_time_tables
    TimeTable.all.each do |time_table|
       next if time_table.description == "Ejecutado"
      ExporterHelper.time_table(time_table) rescue nil
      ExporterHelper.reference_fleet(time_table) rescue nil
    end
  end

  def self.export_time_tables_detail
    TimeTable.all.where.not(commercial_matrix_id: nil,dead_matrix_id: nil).each do |time_table|
      next if time_table.ready_to_process? == "NO" or time_table.description == "Ejecutado"
      ExporterHelper.time_table_detail(time_table) rescue nil
    end
  end

  def self.export_bus_services_detail
    TimeTable.all.where.not(commercial_matrix_id: nil,dead_matrix_id: nil).each do |time_table|
      next if time_table.description == "Ejecutado" or time_table.ready_to_process_with_original? == "NO" 
      ExporterHelper.bus_services_detail(time_table) rescue nil
    end
  end

  def self.export_valley_depot_entries_detail
    TimeTable.all.where.not(commercial_matrix_id: nil,dead_matrix_id: nil).each do |time_table|
      next if time_table.description == "Ejecutado" or time_table.ready_to_process_with_original? == "NO"
      ExporterHelper.valley_depot_entries_detail(time_table) rescue nil
    end
  end     

end
