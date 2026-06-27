# check service status and path
```
systemctl status <serviceName>
```

# check service path
```
systemctl show -p FragmentPath <serviceName>
```

# list all loaded services
```
systemctl list-units --type=service
```

# list all installed services
```
systemctl list-unit-files --type=service
```

# list all loaded but inactive services
```
systemctl --user list-units --type=service -all
```

