Bitcoin-seeder
==============

### About this fork

This is a quick adaptation of sipa/bitcoin-seeder for use with BitcoinCash to be able to feed a DNS seed server with data.

The idea is to be able to run the crawler separately from the DNS server. So you start bitcoin-seeder with "-d 0" (no DNS server thread) so it will just crawl the bitcoin p2p net collecting peer info. Conveniently, bitcoin-seeder dumps this peer-list periodically so filtering and pushing it to some other remote host (DNS server) is a simple matter of some shell scripts (also added to this repo in root folder)

Main changes are
  * add NODE_CASH service bit related values to whitelist
  * cherry-pick some convenience commits from sickpig/bitcoin-seeder
  * dump dnsseed.dump every 100s (not exponetially backing off by a factor of up to 2^5)
  * add some .sh scripts to post-process dnsseed.dump (filtering)

To use the .sh scripts 

```
#> cp config_example.sh config.sh
#> edit config.sh
```

If you want you can put do_filter_dump.sh into your crontab.

### Intro

Bitcoin-seeder is a crawler for the Bitcoin network, which exposes a list
of reliable nodes via a built-in DNS server.

Features:
* Regularly revisits known nodes to check their availability.
* Bans nodes after enough failures, or bad behaviour.
* Keeps statistics over (exponential) windows of 2 hours, 8 hours,
  1 day and 1 week, to base decisions on.
* Very low memory (a few tens of megabytes) and CPU requirements.
* Crawlers run in parallel (by default 24 threads simultaneously).

### Requirements


    sudo apt-get install build-essential libboost-all-dev libssl-dev

### Usage

Assuming you want to run a DNS seed on dnsseed.example.com, you will
need an authorative NS record in example.com's domain record, pointing
to for example vps.example.com:

    $ dig -t NS dnsseed.example.com

    ;; ANSWER SECTION
    dnsseed.example.com.   86400    IN      NS     vps.example.com.

On the system vps.example.com, you can now run `dnsseed`:

    ./dnsseed -h dnsseed.example.com -n vps.example.com -m root.example.com

If you want the DNS server to report SOA records, please provide an
e-mail address (with the @ part replaced by .) using -m.

### Building

Compiling will require boost and ssl.  On debian systems, these are provided
by `libboost-dev` and `libssl-dev` respectively.

    make

This will produce the `dnsseed` binary executable.


### Running as non-root

Typically, you'll need root privileges to listen to port 53 (name service).

One solution is using an iptables rule (Linux only) to redirect it to
a non-privileged port:

    iptables -t nat -A PREROUTING -p udp --dport 53 -j REDIRECT --to-port 5353

If properly configured, this will allow you to run dnsseed in userspace, using
the `-p 5353` option.

Alternatively, non-root binding to privileged ports is possible on Linux supporting
"POSIX capabilities".  If the `setcap` and `getcap` commands are available just issue
this command as root or via sudo

    sudo setcap cap_net_bind_service=+ep /path/to/dnsseed

