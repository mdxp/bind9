bind9 Cookbook
==============
A cookbook to manage bind DNS servers, and zones
Support views,acl,master/slave using keys and many other options.

Here is a repo with my lab , it will give you some good idea of how to use this cookbooks check it out: https://github.com/ramakuka/BInd9-Lab
Requirements
------------
This is a 'library' cookbook, so in order to get the most out of it you will need to have a wrapper cookbook


Attributes
----------
This cookbook relay on attribute define in the wrapper cookbook.

Channle
-------
```node[:bind9][:channel]``` Will be used to configure the channels like rndc or statistics-channels.
the name of the channel should be specify as a hash and it will contain array of config parameters for example:
```
default["bind9"]["channel"]["controls"][1]["inet"] = "127.0.0.1"
default["bind9"]["channel"]["controls"][1]["port"] = "953"
default["bind9"]["channel"]["controls"][1]["allow"] = "any"
default["bind9"]["channel"]["controls"][1]["keys"] = "rndc-key"
```

Keys
----
``` node[:bind9][:keys]``` Will be used to configure the bind keys expample :
```
default["bind9"]["keys"]["rndc"]["algorithm"] = "hmac-md5"
default["bind9"]["keys"]["rndc"]["secret"] = "T8/uYW+mMHzpZLtMC4Vpdw=="
```
ATTENTION! since rndc is critical for bind operation (init script is using it to stop and reload the server) we generated a  key and used it as default. PLEASE CHANEG THE KEY BEFORE USING IT!!! here is a link that explains how it can be done http://www.cyberciti.biz/faq/unix-linux-bind-named-configuring-tsig/

Logs
----
```node[:bind9][:log]``` Will be used to configure the logs and has tow main parts.
the Default log parameter for all categories, it should be defined with attribute ```['bind9'][:log][:logdflt][PARAMTER]```
The defaults are:
```
default['bind9']['logdflt']['version'] = "versions 4 size 100m"
default['bind9']['logdflt']['severity'] = "dynamic"
default['bind9']['logdflt']['print-category'] = "yes"
default['bind9']['logdflt']['print-severity'] = "yes"
default['bind9']['logdflt']['print-time'] = "yes"
```
Changes in the logdflt section will affect all other channels unless the log channel will specify it.
The second part of the log attributes is the log channel. channel must have the following attribute
```
default[:bind9][:log][CHANNLE NAME][:channel]=
default[:bind9][:log][CHANNLE NAME][:logfile]=
```
here is an example
```
default["bind9"]["log"]["queries"]["channel"]= "queries_file"
default["bind9"]["log"]["queries"]["logfile"] = "queries.log"
default["bind9"]["log"]["queries"]["categorychannle"] = "null"
```
More information about bind logs can be found in here: http://www.zytrax.com/books/dns/ch7/logging.html

Options
-------
```node[:bind9][:options]``` Will be used for a configuration in the option section in bind. Attribute can be a key value pair when the key will be the option name and the value will be used as the value or an Array when the key will be used as the option name and the value will be set bind section for this option example
```default[:bind9][:options]["dnssec-validation"] = "auto"``` will be translate to ```dnssec-validation auto;``` in bind
```default[:bind9][:options]["listen-on"] = ['1.1.1.1','2.2.2.2']``` will be translate to
```
listen-on {
1.1.1.1;
2.2.2.2;
};
```
keep in maind that if the value sould be quoted in bind the value should be quoted in the attribute as well, for example
``` default[:bind9][:options]["directory"] = '"/var/named"'``` will translated to ``` directory "/var/named"```

Acl
-------
```node[:bind9][:acl]``` Is a hash of acls that contains an Array of ips
All ACLs will be inputted to named. conf.acl in the bind config directory.
for example :
```
node[:bind9][:acl]= {
	"interal" : ["10/8","192.168/16"],
	"external" : ["any"]
}
```

Views :
------------
views can be used per domain , and should be defined on the provider
By default we asuume you have an ACL for every view - so the default match-clients acl will be the view name . if you want to define a differnat acl to a view use the attribute
```node['bind9']['viewacl'][NAME OF THE VIEW] = ACLNAME```
for example - by default view internal look like this
```
view "internal-view" {
	match-clients { internal; };
		.
		.
	  DOMAINS
		.
		.
	};
```
if you want to use office ACL for the view then you should set up ```node['bind9']['viewacl']['internal'] = 'office'```
```
view "internal-view" {
	match-clients { office; };
		.
		.
	  DOMAINS
		.
		.
	};
```
How to use the cookbook
------------------
Just include the cookbook in your metadata set up the attribute and use the bind9_zone provider to craete new zone for example :

```
bind9_zone "Domain name" do
  email
  nameserver
  type
  ip
  view
end
```
The options are :
domain - Doman Name
ttl - The ttl value for the domain :default => 86400
email - Hosmaster Email to use for the SOA record
view -  The view the domain should be included , leave empty if you don't want to use views
type - Type of domain right now we onlt support master and forward  :default => "master"
ip - if type= forward the ip address of the forward dnss should be specify here

refresh - define SOA refresh default => 3600
retry - define SOA retry  default => 900
expire -  define SOA expire default => 604800
neg_ttl - define the neg_ttl default => 3600
nameserver NS record for the domain
mailserver - define the  mailserver that will be used by the zone
hosts - A hash of hosts and ip address that will configure for the domain
