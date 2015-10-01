require 'tsort'

module Cmap; class JobRunner

  include TSort

  def initialize()
    @jobs = Hash.new{|h,k| h[k] = []}
  end

  alias_method :execute, :tsort

  def add(name, dependencies=[])
    @jobs[name] = dependencies
  end

  def tsort_each_node(&block)
    @jobs.each_key(&block)
  end

  def tsort_each_child(node, &block)
    @jobs[node].each(&block) if @jobs.has_key?(node)
  end

  def execution_path
    execute.reverse
  end

end; end
