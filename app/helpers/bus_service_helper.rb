module BusServiceHelper
require 'csv'

    def self.dead_distance_points(args)
      events_as_json =  args[:events_as_json]
      servbus = args[:servbus]
      events_as_json = events_as_json.select { |event| event["servbus"] == servbus}
      initial_point =   events_as_json.select { |event| event["event_type"] == "punto_de_salida_externo"}.first["punto"]
      final_point =     events_as_json.select { |event| event["event_type"] == "punto_de_entrada_externo"}.first["punto"]
      start_time =      ApplicationHelper.instante_to_decimal(events_as_json.select { |event| event["event_type"] == "punto_de_salida_externo"}.first["instante"])
      finish_time =     ApplicationHelper.instante_to_decimal( events_as_json.select { |event| event["event_type"] == "punto_de_entrada_externo"}.first["instante"])
      amplitude =  finish_time -start_time
      {initial_point: initial_point, final_point: final_point, start_time: start_time, finish_time: finish_time, amplitude: amplitude}
    end

end
