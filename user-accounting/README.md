Basic User Accounting
=====================

These scripts perform basic user accounting from an OpenVPN server.

Overview
--------

OpenVPN exposes details of connecting and disconnecting users to scripts wishing
to use them. The two scripts in this project perform basic logging of useful
details. The scripts are written in POSIX shell, making them portable and
platform-neutral; both GNU and BSD userlands are supported.

License
-------

This is a component of the OpenVPN-dynamic project and is available under a
GPLv3 or BSD 3-clause license as you prefer. See the Licensing/ directory of the
project for the full license text.

Code Copyright Josh Cepek

Usage
-----

Each script that you want to use must be called from the relevant hook in
OpenVPN. The connect and disconnect scripts should be called from the
`--client-connect` and `--client-disconnect` directives, respectively. You may use
either one independently of the other as well.

As written, both scripts collect some values from the environment that pertain
to the client, prepare a log message, and append it to a log file; you should
edit this logfile to one of your choice.

The data logged or the format used may of course be edited if desired for your
environment; a different backend could be substituted as well, such as via
`logger` to use a syslog service, or another backend relevant to your site.

What gets Logged
----------------

The client-connect.sh script logs:

* User commonName
* Date of connection (the current date)
* IP assigned to the client
* Client's connecting IP/port

The client-disconnect script logs:

* User commonName
* IP assigned to the client
* Client's connecting IP/port
* Date of connect/disconnect and connection duration
* Bandwidth transferred each direction in MB

Note that bandwidth is in Megabytes or powers of 10: this means MB and not MiB.

Integrating with Existing Hooks
-------------------------------

If you are already using a script at this hook, you can either integrate the
code into your own, or call this script at the appropriate place from the
existing one. Note that the ordering may be significant here, since you probably
don't want to log a connecting client that you reject in a connect-hook, for
instance. The connect script in this project includes an explicit `exit 0` line
at the end so as not to prevent client connections if appending the log line
failed; edit this to suit your site needs if necessary.
