
if platform_family?("debian")
  default["bind9"]["packages"] = %w{ bind9 dnsutils }
  default["bind9"]["service_name"] = "bind9"
  default["bind9"]["sysconfig"]= "/etc/default/bind9"
  default["bind9"]["dir"]   = "/etc/bind/"
  default["bind9"]["user"]  = "bind"
  default["bind9"]["group"] = "bind"
elsif platform_family?("rhel")
  default["bind9"]["packages"] = %w{ bind bind-utils }
  default["bind9"]["service_name"] = "named"
  default["bind9"]["dir"]   = "/etc/"
  default["bind9"]["user"]  = "named"
  default["bind9"]["group"] = "named"
  default["bind9"]["sysconfig"]= "/etc/sysconfig/named"
end

default["bind9"]["id"] = Hash.new
default["bind9"]["viewacl"]["noview"] = "noview"
default["bind9"]["zonedir"] = "#{node["bind9"]["dir"]}zones"

########################
# Keys - RNDC is very critical to bind normal operation so we used a pre-generated key - PLEAS CHANGE THIS KEY BEFOR USING IT!!!!!!!
########################

default["bind9"]["keys"]["rndc"]["algorithm"] = "hmac-md5"
default["bind9"]["keys"]["rndc"]["secret"] = "T8/uYW+mMHzpZLtMC4Vpdw=="

############################################################
# Controles
############################################################
default["bind9"]["channle"]["controls"][1]["inet"] = "127.0.0.1"
default["bind9"]["channle"]["controls"][1]["port"] = "953"
default["bind9"]["channle"]["controls"][1]["allow"] = "any"
default["bind9"]["channle"]["controls"][1]["keys"] = "rndc-key"

default["bind9"]["channle"]["statistics-channels"][1]["inet"] = "127.0.0.1"
default["bind9"]["channle"]["statistics-channels"][1]["port"] = "8123"
default["bind9"]["channle"]["statistics-channels"][1]["allow"] = "any"
