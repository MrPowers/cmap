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
to_sql = GraphToSql.new("human_lab_data", propositions_to_graph.graph, gsubs)

to_sql.run_queries # returns the following array

[
  "alter table human_lab_data add column seniors int2; update human_lab_data set seniors = 1 where (age > 65);",
  "alter table human_lab_data add column american int2; update human_lab_data set american = 1 where (nationality = 'american');",
  "alter table human_lab_data add column senior_americans int2; update human_lab_data set senior_americans = 1 where (seniors = 1 and american = 1);",
  "alter table human_lab_data add column recently_created_american int2; update human_lab_data set recently_created_american = 1 where (nationality = 'american' and created_at > DATE('2015-01-01') - interval '90' day);",
  "alter table human_lab_data add column kids int2; update human_lab_data set kids = 1 where (age < 12);",
  "alter table human_lab_data add column kid_recently_created_american int2; update human_lab_data set kid_recently_created_american = 1 where (kids=1 AND recently_created_american =1);"
]
```

The `SqlRunner` class can be used to actually run the queries and generate the profiles in the database.

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

