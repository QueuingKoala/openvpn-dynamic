OpenVPN-dynamic Project README
==============================

This project includes a variety of components to integrate with OpenVPN
dynamically as clients connect. This includes support for dynamic firewall
configuration and pushing options to clients.

Licensing
---------

This project is available under a GPLv3 or BSD 3-clause license as you prefer.
The full text of both licenses can be found in the Licensing/ directory.

Components Supported
--------------------

Each component has its own directory, listed below, where the frontend scripts,
sample config files, and component documentation elements are located.

* netfilter - loading dynamic netfilter rules per-client
* user-accounting - basic user accounting on connect and/or disconnect
