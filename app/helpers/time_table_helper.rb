module TimeTableHelper
  require 'csv'

  def self.complete_time_table(events)
    events.sort_by { |event| event["instante"] }
    events.sort_by { |event| event["instante"] }
    bus_service_order = 1
    size = events.size
    events.each_with_index do |event,index|

      if [1,5].include?(event["evento"].to_i) 
        event.merge!({ "commercial_status" => "Sin Procesar"})
      elsif [3,6].include?(event["evento"].to_i) 
        event.merge!({ "dead_status" => "Sin Procesar"})       
      end

      if index == size - 1 or events[index+1]["servbus"] == event["servbus"]
        event.merge!({ "bus_service_order" => bus_service_order})
        bus_service_order = 1 + bus_service_order
      else
        event.merge!({ "bus_service_order" => bus_service_order})
        bus_service_order = 1
      end

      if  event["evento"].to_i == 3
        if index == 0 or events[index-1]["servbus"] != event["servbus"]
          event.merge!({"reference" => "initial_depot", "event_type" => "patio_de_salida_externo"})
        else
          event.merge!({"reference" => "initial_depot", "event_type" => "patio_de_salida_interno"})
        end
      elsif event["evento"].to_i == 5 and events[index-1]["evento"].to_i != 7
        if index == 1 or events[index-2]["servbus"] != event["servbus"]
          event.merge!({"reference" => "initial_point", "event_type" => "punto_de_salida_externo"})
        else
          event.merge!({"reference" => "initial_point", "event_type" => "punto_de_salida_interno"})
        end
      elsif  event["evento"].to_i == 4
        if index == size - 1 or events[index+1]["servbus"] != event["servbus"]
          event.merge!({"reference" => "final_depot", "event_type" => "patio_de_entrada_externo"})
        else
          event.merge!({"reference" => "final_depot", "event_type" => "patio_de_entrada_interno"})
        end
      elsif  event["evento"].to_i == 6 and events[index+1]["evento"].to_i != 7
        if index == size - 2 or events[index+2]["servbus"] != event["servbus"]
          event.merge!({"reference" => "final_point", "event_type" => "punto_de_entrada_externo"})
        else
          event.merge!({"reference" => "final_point", "event_type" => "punto_de_entrada_interno"})
        end
      elsif event["evento"].to_i == 6 
        event.merge!({"event_type" => "cambio_de_linea"})
      end
    end
    events
  end
  
end
