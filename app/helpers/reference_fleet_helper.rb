module ReferenceFleetHelper

  def self.calculate_participation args
    #ReferenceFleetHelper.calculate_participation
    buses_art = args[:buses_art]
    buses_biart = args[:buses_biart]
    km_com_art = args[:km_com_art]
    km_com_biart = args[:km_com_biart]
    reference_fleets = args[:reference_fleets]
    headers = args[:headers]
    array = args[:array]

    a = []
    b = []

    sum_of_array = 0
    sum_of_b = 0

    array.each do |value|
      sum_of_array += value[1] + value[2]
      sum_of_b += value[2]
    end

    resA = []
    resB = []

    calcA = []
    calcB = []

    sum_of_buses = buses_art + buses_biart

    array.each_with_index do |value, index|
      calcA << ((array[index][1] + array[index][2]).to_f / sum_of_array.to_f) * sum_of_buses
      calcB << (array[index][2].to_f / sum_of_b.to_f) * buses_biart
    end

    calcB_rounded = calcB.map{|value| value.round}
    calcA_rounded = calcA.map{|value| value.round}

    calcB.each_with_index do |var, index|
      resB << var % 1
      resA << calcA[index] % 1
    end

    repsB = (calcB_rounded.sum - buses_biart).abs

    if calcB_rounded.sum == buses_biart
      b = calcB_rounded
    elsif calcB.sum > buses_biart
      min_val = (resB - [0]).min
      important_index =resB.index min_val
      calcB_rounded[important_index] -= repsB
      b = calcB_rounded
      resB[important_index] = 0
    else
      max_val = resB.max
      important_index = resB.index max_val
      calcB_rounded[important_index] += repsB
      b = calcB_rounded
      resB[important_index] = 0
    end

    parcialA = calcA.each_with_index.map{|value, index| value.round - b[index] }
    parcialA_rounded = parcialA.map{|value| value.round}

    repsA = (parcialA_rounded.sum - buses_art).abs

    if parcialA_rounded.sum == buses_art
      a = parcialA_rounded
    elsif parcialA_rounded.sum > buses_art
      min_val = (resA - [0]).min
      important_index =resA.index min_val
      parcialA_rounded[important_index] -= repsA
      a = parcialA_rounded
      resA[important_index] = 0
    else
      max_val = resA.max
      important_index = resA.index max_val
      parcialA_rounded[important_index] += repsA
      a = parcialA_rounded
      resA[important_index] = 0
    end

    output = {}

    array.each do |val|
      output[val[0]] = Hash[['a','b'].zip(val[1..-1])]
    end

    output
  end
end


