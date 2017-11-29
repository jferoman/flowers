module ImporterHelper
  require 'csv'

  @directory = "/home/melius/Dropbox/Melius/Investigaciones/Consorcio Express/Reclamacion/"
  @local = "db/data/"

 
  def self.reference_fleet(args)
    error = ""
    file_paths = []

    if args[:file].nil?
      file_paths = Dir.glob(@directory + "tabla_horario/**/"+ args[:file_name] + "/input/**/flota_referente**" + args[:file_name] + ".csv")
    else
      file_paths << args[:file].path
    end
    
    time_table_date = args[:time_table_date]
    time_table = TimeTable.find_by(time_table_date: time_table_date, description: "Original TM")
    return unless time_table.reference_fleets.empty?
    reference_fleets = []

    file_paths.each do |file_path|
      CSV.foreach(file_path , encoding: "iso-8859-1:utf-8", headers: true, :header_converters => :symbol,skip_blanks: true, skip_lines: /^(?:,\s*)+$/) do |reference_fleet|
        reference_fleets << reference_fleet.to_hash.merge(time_table_id: time_table.id)
      end
    end
    begin
      reference_fleets.each {|reference_fleet| reference_fleet.merge!({company_id: Company.find_by(letter: reference_fleet[:letter]).id})}
      ReferenceFleet.bulk_insert values: reference_fleets
      ReferenceFleet.calculate_time_table_reference_fleet_parameters(time_table.id)
    rescue
      nil
    end
  end

  def self.commercial_matrix(args)
    commercial_matrix_date = args[:commercial_matrix_date]

    if args[:file].nil?
      file_path = Dir.glob(@directory +"matriz_comercial/**/matriz_comercial_"+ args[:file_name] + ".csv").first
    else
      file_path = args[:file].path
    end
    commercial_arches = []
    commercial_matrix = CommercialMatrix.find_or_create_by(date_of_creation: commercial_matrix_date)
    commercial_matrix_struct = commercial_matrix.commercial_matrix_struct
    commercial_matrix_date = commercial_matrix.date_of_creation.to_s
    begin
      CSV.foreach(file_path , encoding: "iso-8859-1:utf-8", headers: true, :header_converters => :symbol,skip_blanks: true, skip_lines: /^(?:,\s*)+$/) do |commercial_arch|
        row = commercial_arch.to_hash.slice(:ruta,:macro,:linea,:seccion,:nodo,:abscisa,:nombre).merge(commercial_matrix_id: commercial_matrix.id)
        m_l_s_n = row[:macro].to_s + "_" + row[:linea].to_s + "_" +  row[:seccion].to_s + "_" +  row[:nodo].to_s 
        commercial_arch = commercial_matrix_struct[m_l_s_n]
        commercial_arches << row if commercial_arch.nil?
      end
      CommercialArch.bulk_insert values: commercial_arches 
      commercial_matrix.reload
      commercial_matrix.calculate_distance_to_last_point
      TimeTable.where(commercial_matrix_date: commercial_matrix_date).update_all(commercial_matrix_id: commercial_matrix.id)
      "La matriz comercial " + commercial_matrix_date + " fue cargada correctamente."
    rescue
      "Error en la importacíon de la matriz comercial " + commercial_matrix_date
    end
  end


  def self.dead_matrix(args)

    if args[:file].nil?
      file_path = Dir.glob(@directory +"matriz_de_vacio/**/matriz_de_vacio_"+ args[:file_name] + ".csv").first
    else
      file_path = args[:file].path
    end

    dead_matrix_date = args[:dead_matrix_date]
    dead_distance_arches = []
    dead_matrix = DeadMatrix.find_or_create_by(date_of_creation: dead_matrix_date)
    dead_matrix_fake = dead_matrix.dead_arches.pluck(:arch)
    begin
      CSV.foreach(file_path , encoding: "iso-8859-1:utf-8", headers: true, :header_converters => :symbol,skip_blanks: true, skip_lines: /^(?:,\s*)+$/) do |dead_distance_arch|
        dead_distance_arch = dead_distance_arch.to_hash.except!(:dead_matrix_id)
        decimal_time = ApplicationHelper.instante_to_decimal(dead_distance_arch[:time])
        row = dead_distance_arch.to_hash.merge(dead_matrix_id: dead_matrix.id,decimal_time: decimal_time)
        dead_distance_arches << row if !dead_matrix_fake.include?(row[:arch])
      end
      DeadArch.bulk_insert values: dead_distance_arches
      dead_matrix.reload
      dead_matrix.find_or_create_when_equal_points if !dead_distance_arches.empty?
      TimeTable.where(dead_matrix_date: dead_matrix_date).update_all(dead_matrix_id: dead_matrix.id)
      "La matriz de vacio " + dead_matrix_date.to_s + " fue cargada correctamente."
    rescue
      "Error en la importacíon de la matriz de vacio " + dead_matrix_date.to_s
    end
  end

  def self.executed_bus_service_assignations(args)
   
    file_paths = []
    time_table_date = args[:time_table_date]

    if args[:file].nil?
      file_paths = Dir.glob(@directory + "tabla_horario/**/"+ args[:file_name] + "/input/**/distribucion_ejecutada_**" + args[:file_name] +".csv")
    else
      file_paths << args[:file].path
    end

    begin
      description = "Ejecutado"
      original_time_table = TimeTable.find_by(time_table_date: time_table_date, description: "Original TM")
      return if !TimeTable.find_by(time_table_date: time_table_date, description: description).nil?
      
      time_table = original_time_table.create_duplicate({description: description})
      bus_services = time_table.bus_services
      companies = Company.company_by_gams_code
      bus_service_assignations = []
      
      file_paths.each do |file_path|
        CSV.foreach(file_path , encoding: "iso-8859-1:utf-8", headers: true, :header_converters => :symbol) do |row|
          fase = ApplicationHelper.find_fase(file_path)
          row = row.to_hash

          if fase == "fase_3"
            row[:bus_service_code] = "F3-" + row[:bus_service_code].to_s
          end
          bus_service_assignations << {
            bus_service_id: bus_services.find_by(code: row[:bus_service_code]).id ,
            company_id: Company.find_by(gams_code: row[:company_code]).id,
            initial_depot_id: Depot.find_depot_id({initial_depot: row[:initial_depot]}),
            final_depot_id: Depot.find_depot_id({final_depot: row[:final_depot]}) ,
            valley_depot_id: Depot.find_depot_id({valley_depot: row[:valley_depot]}) ,
            typology_code: row[:typology]
          }
          end
        end
        BusServiceAssignation.bulk_insert values: bus_service_assignations
        time_table.reload
        time_table.update_points_with_executed_format
        time_table.relate_commercial_arches
        time_table.relate_dead_arches
      rescue
        time_table.destroy
      end
    end
  end
