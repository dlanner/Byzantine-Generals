require 'optparse'

class Optparse

  #
  # Return a structure describing the options.
  #
  def self.parse(args)

    # The options specified on the command line will be collected in *options*.
    # We set default values here.
    options = OpenStruct.new
    options.num_nodes = 4
    options.num_traitors = 1
    options.initial_value = 1

    opt_parser = OptionParser.new do |opts|
      opts.on("-n", "--num-nodes=N", Integer, "Total number of nodes/generals to create; defaults to 4") do |n|
        options[:num_nodes] = n || default_num_nodes
      end

      opts.on("-m", "--num-traitors=M", Integer, "A subset of the n nodes, the number of faulty/traitor nodes/generals; defaults to 1") do |m|
        options[:num_traitors] = m || default_num_traitors
      end

      opts.on("-i", "--initial-value=I", Integer, "The initial value given by the commander; defaults to 1") do |i|
        options[:initial_value] = i || default_initial_value
      end

    	opts.on_tail("-h", "--help", "Show this message") do
        puts opts
        exit
      end
    end

    opt_parser.parse!(args)
    options
  end  # parse()
end  # class Optparse
