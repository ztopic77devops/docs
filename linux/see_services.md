# see service status and path
```
systemctl status <serviceName>
```

# see service path
```
systemctl show -p FragmentPath <serviceName>
```

# see all loaded services
```
systemctl list-units --type=service
```

# see all installed services
```
systemctl list-unit-files --type=service
```

# see all loaded but inactive services
```
systemctl --user list-units --type=service -all
```

