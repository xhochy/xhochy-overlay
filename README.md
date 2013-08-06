Installing the overlay
----------------------

1. Copy xhochy-repo.xml into /etc/layman
2. In /etc/layman/layman.cfg add a new line to ``overlays  :`` containing
   `file:///etc/layman/xhochy-repo.xml`
3. `layman -S`
4. `layman -a xhochy`

(These instructions are inspired by [1])

License
-------

Each ebuild should have a header indicating its license. The license may differ
between versions.

[1]: http://assaf-tech.blogspot.de/2011/02/using-github-and-layman-for-my-own.html
