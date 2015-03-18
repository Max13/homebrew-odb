# homebrew-odb
#### A [`Homebrew`](http://brew.sh) tap for [`odb`](http://www.codesynthesis.com/products/odb/) related products.

# Warnings
- The `odb` compiler is a GCC plugin, so it obviously has to be complied with `gcc`. Therefore, `odb` is compiled with the GCC's standard C++ lib: `stdlibc++`. Therefore, the `libodb-*` libraries must also be built with the same standard libs (but not necessarely with `gcc` anymore).

- So, to summerize, installing the `odb` package will install the `gcc` compiler, and to be binary compatible with all that, your final app will also have to use the same standard lib.

- Still confused? Install `odb`, then your app must be linked to `libstdc++`. I hope it's clear.


# Add this tap to `homebrew`
It's very simple. You just have to open your `terminal`, and type:

    % brew tap Max13/odb

After that, you'll have some `odb` related packages available in `brew`.

If you need more information taps: [brew-tap](https://github.com/Homebrew/homebrew/blob/master/share/doc/homebrew/brew-tap.md)

# Install the packages
As long as there is no package submitted to `homebrew`'s master branch with the same names as mine, you can install them as you install any other package:

    % brew install odb

But if you have a doubt, you can specify my prefix:

    % brew install Max13/odb

**Currently, there is no other `odb` nor `libodb-*` packages on the master branch**

# Issues
- If you have an issue during the installation, don't hesitate to check if it's not a known issue, and to submit one if not: [Issues](https://github.com/Max13/homebrew-odb/issues)

- If you have an issue while using it, you'll have to subscribe to the [ODB mailing-lists](http://www.codesynthesis.com/products/odb/mailing-lists.xhtml) (it's a good idea to subscribe anyway, you could help others) and send your question. I'm on it, so I may also help if I can.

# Credits
- *ODB* and its libs are made by [Code Synthesis](http://www.codesynthesis.com), and developped by **Boris Kolpackov**.
- The `homebrew` packages are entirely made by me, with a great help from **Boris Kolpackov** and the mailing-list users.

# Licenses
- *ODB* is licensed under **GPLv2**, but [not only](http://www.codesynthesis.com/products/odb/license.xhtml).
- The `homebrew` packages are licensed under **The MIT License**.