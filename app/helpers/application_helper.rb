module ApplicationHelper
  def controller?(*controller)
    controller.include?(params[:controller])
  end

  def action?(*action)
    action.include?(params[:action])
  end

  def flash_class(level)
      case level
          when :notice  then "alert alert-info"
          when :success then "alert alert-success"
          when :error   then "alert alert-error"
          when :alert   then "alert alert-error"
      end
  end

  def self.instante_to_decimal(instante)
    array = instante.split(":")
    array[0].to_f + array[1].to_f/60 + array[2].to_f/3600
  end

  def self.recal_dead_distance(time_table_id)

    dead_distance_arches_hash = DeadDistanceMatrix.find(args[:dead_distance_matrix_id]).dead_distance_arches_hash
    DeadArch.all.each { |dead_arch| dead_arch.calculate_dead_distance( {dead_distance_arches_hash: dead_distance_arches_hash}) }
  end

  def self.find_fase(path)
    if path.include?("fase_1_y_2")
      result = "fase_1_y_2"
    elsif path.include?("fase_3")
      result = "fase_3"
    else
      result = "unificacion"
    end
    result
  end
  
  def self.hard_fix_of_missing_arches
    #ApplicationHelper.hard_fix_of_missing_arches && ApplicationHelper.update_dead_status
    TimeTable.where(dead_status: "Faltan Arcos").map {|tt| tt.events_dead_statuses}.flatten.uniq.each do |missing_arch|
      next if missing_arch == "OK"
      DeadMatrix.all.each do |dm|
        dead_arch = dm.dead_arches.find_by(arch: missing_arch)
        big_matrix_dead_arch = DeadArch.find_by(arch: missing_arch)
        if dead_arch.nil?
          DeadArch.create(big_matrix_dead_arch.as_json.except("id","created_at","updated_at","dead_matrix_id").merge(dead_matrix_id: dm.id)) rescue nil
        end 
      end
    end
  end

  def self.update_dead_status
    #ApplicationHelper.update_dead_status
    TimeTable.where(dead_status: "Faltan Arcos").each do |tt|
      tt.relate_dead_arches
    end
  end


end


