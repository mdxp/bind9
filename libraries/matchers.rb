if defined?(ChefSpec)
  def create_bind9_zone(zone)
    ChefSpec::Matchers::ResourceMatcher.new(:bind9_zone, :create, zone)
  end

  def create_bind9_reverse(zone)
    ChefSpec::Matchers::ResourceMatcher.new(:bind9_reverse, :create, zone)
  end
end
