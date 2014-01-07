class General
  include Celluloid

  def initialize id, traitorous
    @values = Set.new
    @id = id
    @traitorous = traitorous
  end

  def id
    @id
  end

  def traitor?
    @traitorous
  end

  def oral_message message, num_traitors
    LOGGER.debug "General #{id} got message #{message.value}:#{message.chain.inspect}"
    @values.add message.value
    if num_traitors == 0
      # LOGGER.debug "base case OM(0)"
      @values.to_a.majority
    else
      # LOGGER.debug "recursive case OM(n-1)"
      # TODO: implement traitor strategy mixins (e.g. RandomTraitorStrategy, OppositeTraitorStrategy, etc.)
      new_value = traitor? ? POSSIBLE_VALUES.sample : message.value
      new_message = OpenStruct.new( :value => new_value, :chain => message.chain + [ id ] )
      # LOGGER.debug "Sending message #{new_message.value}:#{new_message.chain.inspect}"
      NUM_LIEUTENANTS.times.map do |i|
        Celluloid::Actor["general#{i+1}".to_sym].future.oral_message new_message, num_traitors - 1
      end.map(&:value)
    end
  end
end
