module BulkParserHelper

  def self.relate_commercial_arches
    TimeTable.all.where.not(commercial_matrix_id: nil).each do |time_table|
      next if time_table.commercial_status == "OK"
      begin
        time_table.relate_commercial_arches 
      rescue
        nil
      end
    end
  end 

  def self.relate_dead_arches
    TimeTable.all.where.not(dead_matrix_id: nil).each do |time_table|
      next  if time_table.dead_status == "OK"
      begin
        time_table.relate_dead_arches
      rescue
        nil
      end
    end
  end
end

     