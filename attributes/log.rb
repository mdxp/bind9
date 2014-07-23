default["bind9"]["loglocation"] = "/var/log/bind/"
#################################################################
# This values are the defalut values for the log channles , values can be overwriten for a specific channle to effect only the chhanle or the dflt to apply it to all channles that do not overwrite it
#################################################################
default["bind9"]["logdflt"]["version"] = "versions 4 size 100m"
default["bind9"]["logdflt"]["severity"] = "dynamic"
default["bind9"]["logdflt"]["print-category"] = "yes"
default["bind9"]["logdflt"]["print-severity"] = "yes"
default["bind9"]["logdflt"]["print-time"] = "yes"
#########################
# Specific channles - more info can be found here : http://www.zytrax.com/books/dns/ch7/logging.html
#########################
default["bind9"]["log"]["default"]["channel"]= "default_file"
default["bind9"]["log"]["default"]["logfile"]= "default.log"

default["bind9"]["log"]["config"]["channel"]= "config_file"
default["bind9"]["log"]["config"]["logfile"]= "config.log"

default["bind9"]["log"]["general"]["channel"]= "general_file"
default["bind9"]["log"]["general"]["logfile"] = "general.log"

default["bind9"]["log"]["network"]["channel"]= "network_file"
default["bind9"]["log"]["network"]["logfile"] = "network.log"

default["bind9"]["log"]["queries"]["channel"]= "queries_file"
default["bind9"]["log"]["queries"]["logfile"] = "queries.log"
default["bind9"]["log"]["queries"]["categorychannle"] = "null"

default["bind9"]["log"]["xfer-in"]["channel"]= "xfer-in"
default["bind9"]["log"]["xfer-in"]["logfile"] = "xferin.log"

default["bind9"]["log"]["xfer-out"]["channel"]= "xfer-out"
default["bind9"]["log"]["xfer-out"]["logfile"] = "xferout.log"
