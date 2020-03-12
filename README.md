# Gandi.net Dynamic DNS Updater
This is a small script I use to update subdomains on my home mac for connecting to while on the road. I have several services that run behind a reverse proxy based on the subdomains. This script runs in cron every so often to make sure the domain always points to the right IP. I already have Crystal installed on the machine and thought this would be a fun way to play with scripting in Crystal. For practical purposes a bash script would work fine as well ; )

This will walk you through setting up this script to work with a domain that you have hosted on gandi.net. I run this on OS X but I _think_ it should work on linux installations as well. 

## Prerequisites
You'll need a working installation of Crystal. On OS X this can be done via `brew`:
```bash
brew update
brew install crystal
```

For linux distros and troubleshooting, see the [install docs](https://crystal-lang.org/install/).

## Steps
### Clone the Repository
```
git clone git@github.com:jaredsmithse/gandi_dyndns_updater.git
cd gandi_dyndns_updater
```

### Edit `dyndns_update.cr`
Using your favorite editor, you'll want to add two things: the domain(s) and your gandi.net API key. Those sections are marked with `FILL_ME_IN` in the file, and some additional comments to help. For your API key, you can see step 1 of this [LiveDNS example](https://doc.livedns.gandi.net) in gandi.net's docs.

### Test Run, Compile, And Move
After filling in the domain/subdomain(s) you want updated, run the following:
```bash
  # run it just to be sure it works
  crystal run dyndns_update.cr
    
  # compile the script to an executable
  crystal build dyndns_update.cr
    
  # remove the one you already have if you've done this before and are adding
  # new domain/subdomain now
  rm /usr/local/bin/dyndns_update
    
  # move the one you just built to the location you want cron to call it from.
  # I put mine in `/usr/local/bin/`
  mv dyndns_update /usr/local/bin/dyndns_update
  
  # remove the files from where you just were running these commands from
  rm dyndns_update*
```

### Have cron Run The Script
After you have it where you want it to be called from, add a line to cron to have it run on an interval (I set mine to every 30m). First run `crontab -e` and add the following on a new line:
```bash
*/30 * * * * /bin/bash /usr/local/bin/dyndns_update
```

If you put your script in a different place, be sure to use that URL instead.

### Other Notes
To make sure the URL does not change as often, it would likely make sense to have a static IP address on your router. Because of the large variation between routers, I will not include instructions for that here. You'll also want to setup port forwarding depending on the service you're running, and make sure that the port is forwarded and open on both the router and host computer. 