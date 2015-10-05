# Cmap

The cmap gem converts the 'Propositions to Text' export file into a directed graph data structure.  The graph can then be converted into a series of postgres SQL queries to generate profiles.

Suppose we start with the following directed graph:

![](https://github.com/MrPowers/cmap/blob/master/pictures/cmap_example.png)

And the following starting database state:

![](https://github.com/MrPowers/cmap/blob/master/pictures/db_starting.png)

cmaps can be exported as a tab delimited text file of the graph edges with the "Propositions to Text" option.  The `Cmap::PropositionsToGraph` is meant to be instantiated with the path to one of these "Propositions to Text" exports.

```ruby
propositions_to_graph = Cmap::PropositionsToGraph.new("/path/to/propositions_to_text_file")
propositions_to_graph.graph # a DirectedGraph::Graph object
```

The `GraphToSql` class is instantiated with the `DirectedGraph::Graph` object and converts the graph to an array of SQL queries:

```ruby
propositions_to_graph = Cmap::PropositionsToGraph.new("/path/to/propositions_to_text_file")
today = "'2015-01-01'"
gsubs = [["90D", "created_at > DATE(#{today}) - interval '90' day"]]
to_sql = GraphToSql.new("human_lab_data", propositions_to_graph.graph, {dbname: "cmap_test"}, gsubs)

# the database must be seeded with the starting data first

to_sql.run_queries
```

The `#run_queries` method add columns to the `human_lab_data` table to generate the profiles.

![](https://github.com/MrPowers/cmap/blob/master/pictures/db_ending.png)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'cmap'
```

And then require the gem in your project:

```ruby
require 'cmap'
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/MrPowers/cmap.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

