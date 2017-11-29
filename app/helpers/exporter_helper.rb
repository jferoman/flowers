module ExporterHelper
  require 'csv'
  require 'application_helper'
  @directory = "/home/melius/Dropbox/Melius/Investigaciones/Consorcio Express/Reclamacion/output_redo_segundo/"
  @local = "db/data/"

  def self.time_table(time_table)
    file_name = time_table.time_table_date.strftime("%Y%m%d")
    events = time_table.events

    CSV.open( @directory + file_name + "_tabla_horario" + ".csv", "wb") do |csv|
      csv << events.first.attributes_to_csv.keys
      events.each do |event|
        csv <<  event.attributes_to_csv.values
      end
    end

    return @directory + file_name + "_tabla_horario"+".csv"
  end

  def self.time_table_detail(time_table)
    events = time_table.events
    file_name = time_table.time_table_date.strftime("%Y%m%d")
    parsed_events = []
 

    events.as_json(include: [:dead_arch, :commercial_arch]).each do |event|
      event.except!("id","updated_at","created_at","bus_service_id","commercial_arch_id","dead_arch_id")
      dead_arch = {"initial_point" => nil,"final_point" => nil,"arch" => nil,"distance" => nil,"decimal_time" => nil}
      commercial_arch = {"distance_to_last_point" => nil,"ruta" => nil}
      dead_arch = event["dead_arch"].slice("initial_point","final_point","arch","distance","decimal_time") unless event["dead_arch"].nil?
      commercial_arch = event["commercial_arch"].slice("distance_to_last_point","ruta") unless event["commercial_arch"].nil?

      parsed_events << event.except("dead_arch", "commercial_arch").merge(dead_arch).merge(commercial_arch)
    end
    
    parsed_events.sort_by! {|pe| pe["instante"]}
    parsed_events.sort_by! {|pe| pe["servbus"]}

    CSV.open(@directory + file_name + "_detalle_tabla_horario.csv", "wb") do |csv|
      csv << parsed_events.first.keys 
      parsed_events.each do |parsed_event|
       csv << parsed_event.values
      end
    end
    return @directory + file_name + "_detalle_tabla_horario.csv"
  end


  def self.bus_services_detail(time_table)
    file_name = time_table.time_table_date.strftime("%Y%m%d")

    args = {
      depots: Depot.all,
      dead_arches_struct: time_table.dead_matrix.dead_arches_struct(time_table)
    }

    bus_services = time_table.bus_services
    CSV.open(@directory + file_name + "_parametros_servbuses.csv", "wb") do |csv|
      csv << bus_services.first.complete_attributes_to_csv(args).keys

      bus_services.each do |bus_service|
        csv << bus_service.complete_attributes_to_csv(args).values
      end
    end

    return @directory + file_name + "_parametros_servbuses.csv"
  end


  def self.valley_depot_entries_detail(time_table)
    file_name = time_table.time_table_date.strftime("%Y%m%d")

    args = {
      dead_arches_struct: time_table.dead_matrix.dead_arches_struct(time_table),
    }

    valley_depot_entries = time_table.valley_depot_entries

    CSV.open(@directory + file_name + "_entradas_a_patio.csv", "wb") do |csv|
      csv << valley_depot_entries.first.complete_attributes_to_csv(args).keys

      valley_depot_entries.each do |valley_depot_entry|
        csv << valley_depot_entry.complete_attributes_to_csv(args).values
      end
    end

    return @directory + file_name + "_entradas_a_patio.csv"
  end

  def self.reference_fleet(time_table)
    reference_fleets = time_table.reference_fleets
    file_name = time_table.time_table_date.strftime("%Y%m%d")

    CSV.open(@directory + file_name + "_flota_referente.csv", "wb") do |csv|
      csv << reference_fleets.first.complete_attributes_to_csv.keys
      
      reference_fleets.each do |reference_fleet|
        csv << reference_fleet.complete_attributes_to_csv.values
      end
    end

    return @directory + file_name + "_flota_referente.csv"
  end

  def self.gams_model(time_table)
    time_table = TimeTable.find(time_table_id)
    file_path = time_table.fecha_de_th.strftime("%Y%m%d")

    serbuses = time_table.time_table_rows.pluck(:servbus).join(',')

    result_model = IO.read('db/data/base.gms') % {
      :serbuses => serbuses,
      :date => file_path,
      :directory => @directory
    }
    File.open( @directory +"model/distribution_normal" +file_path+'.gms', 'w') { |file| file.write(result_model) }
    return @directory +"model/distribution_normal" +file_path+'.gms'
  end

  def self.export_commercial_matrix args
    commercial_distance_matrix = CommercialMatrix.find_by(date_of_creation: args[:date_of_creation])
    commercial_arches = commercial_distance_matrix.commercial_arches
    date = commercial_distance_matrix.date_of_creation.strftime("%Y%m%d")
    attributes = %w{ruta macro linea seccion nodo abscisa nombre distance_to_last_point}


    CSV.open( @directory + "/matriz_comercial/matriz_comercial_"+ date +".csv", "wb") do |csv|
      csv << attributes

      commercial_arches.each do |commercial_arch|
        csv << attributes.map{ |attr| commercial_arch.send(attr) }
      end
    end
    return @directory + "/matriz_comercial/matriz_comercial_"+ date +".csv"
  end


  def self.export_dead_matrix args
    dead_matrix  = DeadMatrix.find_by(date_of_creation: args[:date_of_creation])
    dead_arches = dead_matrix.dead_arches
    date = dead_matrix.date_of_creation.strftime("%Y%m%d")
    attributes = %w{initial_point final_point arch time distance}

    CSV.open(@directory + "/matriz_de_vacio/matriz_de_vacio_"+ date +".csv", "wb") do |csv|

      csv << attributes

      dead_arches.each do |dead_arch|
        csv << attributes.map{ |attr| dead_arch.send(attr) }
      end
    end

    return @directory + "/matriz_de_vacio/matriz_de_vacio_"+ date +".csv"

  end

  def self.executed_distribution_proposal time_table
    args = {
      name: "ejecutado",
      time_table: time_table
    }
    export_distribution_proposal(args)
  end

  def self.export_distribution_proposal args
    time_table = args[:time_table].time_table
    bus_service_assignations = DistributionProposal.find_by(name: args[:name],time_table_id: time_table.id).bus_service_assignations
    file_name = time_table.time_table_date.strftime("%Y%m%d")

    attributes = BusServiceAssignation.first.attributes.keys

    CSV.open(@directory +file_name +"_" + args[:name] + "_propuesta.csv", "wb") do |csv|

      csv << attributes
      bus_service_assignations.each do |bus_service_assignation|
        csv << attributes.map{ |attr| bus_service_assignation.send(attr) }
      end
    end
    return @directory + file_name +"_" + args[:name] + "_propuesta.csv"
  end


end

