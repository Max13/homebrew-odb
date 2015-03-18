# homebrew-odb
#### A [`Homebrew`](http://brew.sh) tap for [`odb`](http://www.codesynthesis.com/products/odb/) related products.

# Add this tap to homebrew
It's very simple. You just have to open your `terminal`, and type:

    % brew tap Max13/odb # <-- Case insensitive

After that, you'll have some `odb` related packages available in `brew`.

If you need more information taps: [brew-tap](https://github.com/Homebrew/homebrew/blob/master/share/doc/homebrew/brew-tap.md)

# Warnings
- The `odb` compiler is a GCC plugin, so it is compiled with `gcc` and its C++ standard library (`libstdc++`).

- To be binary compatible (and to avoid runtime issues), you need to compile `libodb` and it's packages with the same C++ standard library (most packages accept 3 standard libs).

# Install a package
As long as there is no package submitted to `homebrew`'s master branch with the same names as mine, you can install them as you install any other package:

    % brew install odb

But if you have a doubt, you can specify my prefix:

    % brew install Max13/odb

**Currently, there is no other `odb` nor `libodb-*` packages on the master branch**

# C++ Standard Library and build options
What is the standard library you're compiling your app with? Currently, I give you 3 choices (with default):

- GCC's **libstdc++**: `--with-gcc`
- Apple's **libstdc++**: `--with-libstdc++` (OSX < 10.9 - Mavericks)
- Apple's **libc++**: `--with-libc++` (OSX >= 10.9 - Mavericks)

GCC's option is there for clang haters ;)

If you use `Qt`'s framework, you must choose `--with-libstdc++`

# Issues
- If you have an issue during the installation, don't hesitate to check if it's not a known issue, and to submit one if not: [Issues](https://github.com/Max13/homebrew-odb/issues)

- If you have an issue while using it, you'll have to subscribe to the [ODB mailing-lists](http://www.codesynthesis.com/products/odb/mailing-lists.xhtml) (it's a good idea to subscribe anyway, you could help others) and send your question. I'm on it, so I may also help if I can.

# Credits
- *ODB* and its libs are made by [Code Synthesis](http://www.codesynthesis.com), and developped by **Boris Kolpackov**.
- The `homebrew` packages are entirely made by me, with a great help from **Boris Kolpackov** and the mailing-list users.

# Licenses
- *ODB* is licensed under **GPLv2**, but [not only](http://www.codesynthesis.com/products/odb/license.xhtml).
- The `homebrew` packages are licensed under **The MIT License**.
