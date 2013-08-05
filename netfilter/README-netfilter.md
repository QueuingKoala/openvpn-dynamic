netfilter dynamic-openvpn README
================================

The use of the netfilter component allows dynamic firewall rules to be applied
when a given client connects, identified by its OpenVPN common name.

Using netfilter rule files
--------------------------

The rules that are provided on a per-client basis (and one that can be loaded on
OpenVPN startup) are in iptables-save(8) syntax. The rules are loaded via
iptables-restore with the '-n' switch, which will not flush the existing
ruleset.

In particular, this means you do not need to include the builtin chains
or their policies in the config file. Often all that is required is the \*filter
table start, the rules for this client, and the ending COMMIT line.

The IP that has been assigned by OpenVPN to the client will be replaced where
the string <IP> appears. Examples can be found in the examples/ directory.

Overview to the loading process
-------------------------------

An up.sh script is provided that, on init, looks in the defined dynamic\_dir
path for a file named DEFAULT:init and, if present, loads it. This is useful for
clearing out custom VPN firewall chains (such as when stale rules are left after
an application crash or terminiation.)

When clients connect, the client-connect.sh script will look in the dynamic\_dir
path for a file named CN:fw where "CN" is the client's common name as defined in
openvpn(8) (note character remapping applies here if you haven't disabled it in your
OpenVPN config.) If present, this file will be coppied to the state\_dir for
future unloading, and then loaded into netfilter. This state directory is
important as the client rule file may have changed since loading.

When clients disconnect that had dynamnic rules applied, any -A or -I commands
in the rule file are replaced with -D (delete) to remove the applied rules.

It is required to use these scripts, or insert a call to them (or the inline
code directly) into your --up, --client-connect, and --client-disconnect OpenVPN
directives for each component of this process to take effect.

Tips for integrating rules the smart way
----------------------------------------

It is recommended to use a unique chain, such as the "vpn\_fw" chain the
examples use. The benefit is that the per-client rules can use the -A (append)
netfilter syntax without having to worry about inserting (-I) above earlier
rules in the FORWARD chain. Consult the netfilter-os.rules file for a very basic
example of how you might set up your own ruleset.

Generally, you will load your own ruleset through your preferred mechanism well
before OpenVPN starts (distros usually have their own way of doing this on boot
or networking startup.) your OS ruleset should include the template chains that
you wish to use for filtering VPN traffic, and relevant jumps to them (such as
to send traffic to/from your VPN network to this custom chain.)

As clients connect that have dynamic rules, the rules will get loaded to this
chain, and unloaded as they disconnect, and if OpenVPN restarts, the
DEFAULT:init file allows this chain to be cleanly flushed by placing a -F
command in the rulefile (as the example shows.)
