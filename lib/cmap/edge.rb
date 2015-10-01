module Cmap

  class Edge

    attr_reader :origin_vertex, :destination_vertex, :value

    def initialize(origin_vertex, value, destination_vertex)
      @origin_vertex = origin_vertex
      @destination_vertex = destination_vertex
      @value = value
    end

  end


end

