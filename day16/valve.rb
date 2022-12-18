class Valve
  attr_reader :key, :flow_rate, :tunnels

  def initialize(key:, flow_rate:, tunnels:)
    @key = key
    @flow_rate = flow_rate
    @tunnels = tunnels
  end

  def to_s
    key
  end
end
