dev-server
==========

Script to get my development server up and running. This probably shouldn't be
used by anyone else without heavy modification.


Getting Started
---------------

This pulls the latest from GitHub on a fresh system and then runs setup::

    curl "https://raw.githubusercontent.com/overshard/dev-server/master/bootstrap.sh" | sh

If you already have the repo pulled you can run::

    ./setup.sh


User Setup
----------

This assumes that you already have a user setup and are logged in as that user.
If you do not have a user yet, create one::

    adduser isaac
    adduser isaac sudo

Make this will setup the new user and add them to the sudo group for admin
capabilities. Make sure you setup the `.ssh` folder with `authorized_keys` so
that you can ssh in as the new user.

