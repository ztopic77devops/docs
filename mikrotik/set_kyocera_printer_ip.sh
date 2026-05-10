#
# this mikrotik script will find new kyocera printer connected to mikrotik
# and will set address to 192.168.x.10 where x is location number took from local ip range
# example: if location 007 have ip range 192.168.7.0/24 this script will will set printer ip to 192.168.7.11
#
```
:local myemail "email@domain.com";
:local done false;
:local ipaddress "$[/ip address get [ find where interface="ether5"] address ]";
:local shopcode [:pick $ipaddress 7 [:find $ipaddress ".1/24"]];
:local activeaddress "";

:do {

	:local printercount 0

	:foreach j in=[/ip dhcp-server lease find dynamic active-mac-address~"00:17:C8" last-seen<15m] do={
		:set printercount ($printercount+1)
		:log info ("new printer found: " . [/ip dhcp-server lease get $j active-mac-address]);
		:set $activeaddress [/ip dhcp-server lease get $j active-address];
	}

	:if ($printercount = 0) do={
		:log info "		:log info "there is no new printers on the network""
	}

	:if ($printercount > 1) do={
		:log error "more then one printer found in DHCP leases"
	}

	:if ($printercount = 1) do={
		/ip dhcp-server lease remove [find address=("192.168.".$shopcode.".10")];
		:foreach j in=[/ip dhcp-server lease find dynamic active-mac-address~"00:17:C8" last-seen<15m] do={
			/ip dhcp-server lease make-static $j;
			/ip dhcp-server lease set address=("192.168.".$shopcode.".10") comment="printer" $j;
		}

	:set done true;
	}

}

if ($done = true) do={
	/tool e-mail\ 
		send to=$myemail\
		body="for activation restart the printer."\
		subject="$[/system identity get name] -- new printer connected"

}

```