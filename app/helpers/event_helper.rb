module EventHelper
  def self.update_bulk_commercial_arches_id update_event
    commercial_arch_ids_values = ""
    commercial_arch_status_values = ""
    update_event.each do |ue|
      if !ue[:commercial_arch_id].nil?
        commercial_arch_ids_values << "(" + ue.except(:commercial_arch_status).values.join(', ') + "),"
      end
      commercial_arch_status_values << "(" + ue[:id].to_s +  ",'" + ue[:commercial_arch_status].to_s + "'),"
    end
    commercial_arch_ids_values = commercial_arch_ids_values[0...-1]
    commercial_arch_status_values = commercial_arch_status_values[0...-1]
      
    ActiveRecord::Base.connection.execute(
      "update events as t set
          commercial_arch_id = c.commercial_arch_id
      from (values
          #{commercial_arch_ids_values}
      ) as c(id, commercial_arch_id)
      where c.id = t.id"
    )

     ActiveRecord::Base.connection.execute(
      "update events as t set
          commercial_arch_status = c.commercial_arch_status
      from (values
          #{commercial_arch_status_values}
      ) as c(id, commercial_arch_status)
      where c.id = t.id"
    )
  end

  def self.update_bulk_dead_arches_id update_event
   dead_arch_ids_values = ""
    dead_arch_status_values = ""
    update_event.each do |ue|
      if !ue[:dead_arch_id].nil?
        dead_arch_ids_values << "(" + ue.except(:dead_arch_status).values.join(', ') + "),"
      end
      dead_arch_status_values << "(" + ue[:id].to_s + ",'" + ue[:dead_arch_status].to_s + "'),"
    end
    dead_arch_ids_values = dead_arch_ids_values[0...-1]
    dead_arch_status_values = dead_arch_status_values[0...-1]

    ActiveRecord::Base.connection.execute(
      "update events as t set
          dead_arch_id = c.dead_arch_id
      from (values
          #{dead_arch_ids_values}
      ) as c(id, dead_arch_id)
      where c.id = t.id"
    )

    ActiveRecord::Base.connection.execute(
      "update events as t set
          dead_arch_status = c.dead_arch_status
      from (values
          #{dead_arch_status_values}
      ) as c(id, dead_arch_status)
      where c.id = t.id"
    )
  end
end


