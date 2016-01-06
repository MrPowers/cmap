module Cmap; class SanitizeGraph

	def initialize(graph)
		@graph = graph
	end

	def sanitize
		sanitize_vertices
    set_sanitized_value_in_edges
		sanitize_edges
		@graph
	end

	private

	def sanitize_vertices
		@graph.vertices.each { |v| v.data[:sanitized_name] = sanitize_string(v.data[:name]) }
	end

  def set_sanitized_value_in_edges
    @graph.edges.each do |edge|
      edge.data[:sanitized_value] = edge.data[:value]
    end
  end

	def ordered_vertices
		# HACK: this sorting makes the assumption vertices lower in the graph have longer ids
		@ordered_vertices ||= @graph.vertices.sort do |a, b|
			b.name.length <=> a.name.length
		end
	end

	def sanitize_edges
    @graph.edges.each { |edge| sanitize_edge(edge) }
  end

  def sanitize_edge(edge)
    ordered_vertices.each do |v|
    	edge.data[:sanitized_value] = edge.data[:sanitized_value].gsub(v.data[:name], v.data[:sanitized_name])
    end
  end

  private

  def sanitize_string(string)
    string.gsub(/[^0-9a-zA-Z]+/, '_').downcase
  end

end; end
