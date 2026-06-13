#
# this mikrotik script will find new PC connected to mikrotik
# and will set address to 192.168.x.11 where x is location number took from local ip range
# example: if location 007 have ip range 192.168.7.0/24 this script will set PC ip to 192.168.7.11
# note: that pc hostname must be <location_number-001> for example 007-001
#
```
:local myemail "email@domain.com";
:local done false;
:local ipaddress "$[/ip address get [ find where interface="ether5"] address ]";
:local shopcode [:pick $ipaddress 7 [:find $ipaddress ".1/24"]];
:local activeaddress "";
:local shopid [:pick "$[/system identity get name]" 14 17];


:do {

	:local pccount 0

	:foreach j in=[/ip dhcp-server lease find dynamic host-name=(""$shopid."-001") last-seen<15m] do={
		:set pccount ($pccount+1)
		:log info ("new pc found: " . [/ip dhcp-server lease get $j active-mac-address]);
		:set $activeaddress [/ip dhcp-server lease get $j active-address];
	}

	:if ($pccount = 0) do={
		:log info "there is no new pc on the network"
	}

	:if ($pccount > 1) do={
		:log error "more then one pc found in DHCP leases"
	}

	:if ($pccount = 1) do={
		/ip dhcp-server lease remove [find address=("192.168.".$shopcode.".11")];
		:foreach j in=[/ip dhcp-server lease find dynamic host-name=(""$shopid."-001") last-seen<15m] do={
			/ip dhcp-server lease make-static $j;
			/ip dhcp-server lease set address=("192.168.".$shopcode.".11") comment="OTC" $j;
		}

	:set done true;
	}

}

if ($done = true) do={
	/tool e-mail\ 
		send to=$myemail\
		body=("new ps is connected on mikrotik $[/system identity get name] and have ip ("192.168.".$shopcode.".11"). for activation restart pc.")\
		subject="$[/system identity get name] -- new pc connected"

}

```