# homebus-webhook

This is a very rudimentary webhook server.

You manually configure it with webhook applications via the Rails
console. There is currently no API for this.

It's deeply insecure and will execute any readable program anywhere on
the system. You must not run it as root.

It should be rewritten to provide an API that a central server can use
to configure it, and to only run applications in containers so that
they're isolated from the rest of the system.
