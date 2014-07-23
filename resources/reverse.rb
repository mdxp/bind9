actions :create

default_action :create
 
attribute :domain, :kind_of => String, :name_attribute => true
attribute :ttl, :kind_of => Integer, :default => 86400
attribute :email, :kind_of => String, :required => true
attribute :view,  :kind_of => String, :default => "noview"
attribute :type,  :kind_of => String, :default => "master"


attribute :refresh, :kind_of => Integer, :default => 3600
attribute :retry, :kind_of => Integer, :default => 900 #Denic minimum
attribute :expire, :kind_of => Integer, :default => 604800 #Denic minimum
attribute :neg_ttl, :kind_of => Integer, :default => 3600


attribute :nameserver, :kind_of => Array, :default => Array.new
attribute :hosts, :kind_of => Hash, :default => Hash.new
