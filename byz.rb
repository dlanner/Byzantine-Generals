require 'celluloid'
require 'ostruct'
require 'logger'

load 'monkey_patches.rb'
load 'general.rb'

NUM_NODES = 10
NUM_LIEUTENANTS = NUM_NODES - 1
NUM_TRAITORS = 3

LOGGER = Logger.new(STDOUT)

traitors = Set.new
traitors.add(rand(NUM_NODES)) while traitors.size < NUM_TRAITORS
LOGGER.info "Generals #{traitors.to_a.to_s} are traitors"

Celluloid::Actor[:commander] = General.new 0, traitors.include?(0)

NUM_LIEUTENANTS.times do |i|
  id = i+1
  Celluloid::Actor["general#{id}".to_sym] = General.new id, traitors.include?(id)
end

values = Celluloid::Actor[:commander].oral_message OpenStruct.new( :value => 1, :chain => [] ), NUM_TRAITORS
value = values.recursive_majority
LOGGER.info "Consensus value: #{value}"