require 'celluloid'
require 'ostruct'
require 'logger'

load 'monkey_patches.rb'
load 'general.rb'
load 'optparser.rb'

options = Optparse.parse(ARGV)
NUM_NODES = options[:num_nodes]
NUM_LIEUTENANTS = options[:num_nodes] - 1
NUM_TRAITORS = options[:num_traitors]
INITIAL_VALUE = options[:initial_value]
POSSIBLE_VALUES = [0,1]
LOGGER = Logger.new(STDOUT)

def setup
  traitors = Set.new
  traitors.add(rand(NUM_NODES)) while traitors.size < NUM_TRAITORS
  case NUM_TRAITORS
  when 1 then LOGGER.info "General #{traitors.first} is a traitor"
  else LOGGER.info "Generals #{traitors.to_a.to_s} are traitors"
  end

  commander_id = 0
  Celluloid::Actor[:commander] = General.new commander_id, traitors.include?(commander_id)

  NUM_LIEUTENANTS.times do |i|
    id = i+1
    Celluloid::Actor["general#{id}".to_sym] = General.new id, traitors.include?(id)
  end
end

def start
  setup
  initial_message = OpenStruct.new( :value => INITIAL_VALUE, :chain => [] )
  num_rounds = NUM_TRAITORS + 1
  values = Celluloid::Actor[:commander].oral_message initial_message, num_rounds
  value = values.recursive_majority
  LOGGER.info "Consensus value: #{value}"
end

start()