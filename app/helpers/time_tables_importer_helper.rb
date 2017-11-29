module TimeTablesImporterHelper
  require 'csv'

  @directory = "/home/melius/Dropbox/Melius/Investigaciones/Consorcio Express/Reclamacion/"
  @local = "db/data/"

  def self.relate_time_table_and_import(file_path)
    CSV.foreach(file_path , encoding: "iso-8859-1:utf-8", headers: true, :header_converters => :symbol) do |time_table|
      next if time_table.to_hash[:time_table_date].nil? or TimeTable.find_by(time_table_date: time_table[:time_table_date], description: "Original TM")
      
      begin
      hash_time_table  = time_table.to_hash
        iph_date = IphDate.find_or_create_by(date_of_creation: time_table[:time_table_date])
        time_table = TimeTable.find_or_create_by(time_table_date: time_table[:time_table_date], description: "Original TM", iph_date_id: iph_date.id)
      
        time_table.update(hash_time_table)
        TimeTablesImporterHelper.time_table({time_table_date: time_table.time_table_date,file_name: time_table.time_table_date.strftime("%Y%m%d")})
        commercial_matrix = CommercialMatrix.find_by(date_of_creation: hash_time_table[:commercial_matrix_date])
        dead_matrix = DeadMatrix.find_by(date_of_creation: hash_time_table[:dead_matrix_date])

        time_table.update(commercial_matrix_id: commercial_matrix.id) unless commercial_matrix.nil? or !time_table.commercial_arches_events.empty?
        time_table.update(dead_matrix_id: dead_matrix.id) unless dead_matrix.nil? or !time_table.dead_arches_events.empty?

      rescue
        time_table.delete rescue nil
        return "Error en la Importacion de Tabla Horario"
      end
    end
  end

  def self.time_table(args)
    time_table_date = args[:time_table_date]
    description = args[:description]

    if description.nil?
      description = "Original TM"
    end

    file_paths = []

    if args[:file].nil?
      file_paths = Dir.glob(@directory + "tabla_horario/**/"+ args[:file_name] + "/input/**/tabla_horario**" + args[:file_name] + ".csv")
    else
      file_paths << args[:file].path
    end

    events = []
    iph_date = IphDate.find_by(date_of_creation: time_table_date)

    time_table_args = {
      time_table_date: time_table_date,
      description: description
    }
    time_table_args.merge!({iph_date_id: iph_date.id}) if !iph_date.nil?
    time_table = TimeTable.find_or_create_by(time_table_args)

    unless args[:commercial_matrix_id].nil? or args[:dead_matrix_id].nil? 
      commercial_matrix = CommercialMatrix.find(args[:commercial_matrix_id])
      dead_matrix = DeadMatrix.find(args[:dead_matrix_id])
      args_time_table = {
        commercial_matrix_id: commercial_matrix.id, 
        dead_matrix_id: dead_matrix.id,
        commercial_matrix_date: commercial_matrix.date_of_creation,
        dead_matrix_date: dead_matrix.date_of_creation
      }
      time_table.update(args_time_table) 
    end
   
    begin
      file_paths.each do |file_path|
        fase = ApplicationHelper.find_fase(file_path)
        CSV.foreach(file_path , encoding: "iso-8859-1:utf-8", headers: true, :header_converters => :symbol,skip_blanks: true, skip_lines: /^(?:,\s*)+$/) do |event|
          event = event.to_hash.merge(time_table_id: time_table.id, fase: fase)
          if fase == "fase_3"
            event[:servbus] = "F3-" + event[:servbus].to_s
          end
          events << event
        end
      end
    rescue
      time_table.delete
      return  "Archivo en directorio "+ file_path + " no fue encontrado. -"
    end

    begin
      time_table.initial_parsing(events.as_json)
      time_table.create_valley_depot_entries
      "Tabla horario " + time_table_date.to_s + " fue cargada correctamente."
    rescue
      time_table.events.destroy_all
      time_table.bus_services.destroy_all
      time_table.delete
      return  "Error en la importacíon de Eventos para tabla horario " + time_table_date.to_s
    end
  end
end
