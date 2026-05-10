#
# this mikrotik script will check remote http server
# if file srvVRS.txt on remote server is different from locVRS.txt on mikrotik
# file config will be pulled from server to mikrotik, mikrotik CLI commands from config file will be applied
# and locVRS.txt will be updated with srvVRS.txt content
# 
```
:local error false

:if ([:len [file find name="locVRS.txt"]]!=1) do={
	/file print file="locVRS.txt"
}

:do {
	/tool fetch url="http://<server_ip_address>/mikrotik/srvVRS.txt" mode=http
		} on-error={
			:set error true
			:log error "error while fetching srvVRS file"
}

:if ($error = false) do={
	{delay 1};
	:local locVRS [/file get locVRS.txt contents]
	:local srvVRS [/file get srvVRS.txt contents]

	:if ($locVRS != $srvVRS) do={
		:do {
			/tool fetch url="http://<server_ip_address>/mikrotik/config" mode=http
		} on-error={
			:set error true
			:log error "error while fetching config file"
		}
		
		:if ($error = false) do={
			:do {
				{delay 3};
				/import file-name="config"
			} on-error={
				:set error true
				:log error "error while importing config file"
			}
			
			:if ($error = false) do={
				/file set contents=$srvVRS locVRS.txt
				{delay 5};
				/file remove config
			}
		}
	} else={
		:log info "srvVRS same as locVRS"
		
	}
}

/file remove srvVRS.txt

```