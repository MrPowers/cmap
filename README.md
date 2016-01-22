# Cmap

The cmap gem converts the 'Propositions to Text' export file into a directed graph data structure (with the [directed_graph gem](https://github.com/mrpowers/directed_graph).

cmaps can be exported as a tab delimited text file of the graph edges with the "Propositions to Text" option.  The `Cmap::PropositionsToGraph` is meant to be instantiated with the path to one of these "Propositions to Text" exports.

```ruby
propositions_to_graph = Cmap::PropositionsToGraph.new("/path/to/propositions_to_text_file")
propositions_to_graph.graph # a DirectedGraph::Graph object
```

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
