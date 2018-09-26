fmap is a fake version of the nmap application, destined to
scan the port status of a host.
For use this script, you first need install thor, a tool of
self-documentation that fmap use.

1 - $ gem install thor

2 - $ thor fmap:scan {ARGS}

Use:
  thor fmap:help [COMMAND]     # Describe available commands or one specific command
  thor fmap:scan DIRECCION_IP  # Receive an IP Address and get status of the first 1000 ports

Options:
  -p, [--a-port=N]             # Scan a specific port (Example: -p 80)
  -r, [--range=one two three]  # Scan a range of ports (Example: -r 1 999)


Examples:

Scan 1000 first ports of the localhost

$ thor fmap:scan 127.0.0.1 


Scan port 80 of the google.com

$ thor fmap:scan 8.8.8.8 -p 80


Scan range of ports on the localhost

$ thor fmap:scan localhost -p 55 999