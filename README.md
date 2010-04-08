TomDoc
======

See [the manual][man] or [the spec][spec] for the overview.

The remainder of this README will cover the Ruby library for parsing
TomDoc and generating documentation from it.


Installation
------------

    easy_install Pygments
    gem install ruby_parser -v 2.0.4
    gem install colored
    git clone git@github.com:defunkt/tomdoc.git
    cd tomdoc
    rake gem:install

This will generate a RubyGem and run `gem install GEM` to install
it. You can uninstall it at any time:

    gem uninstall tomdoc

tomdoc.rb has been tested with Ruby 1.8.7-p173 and REE 1.8.7-p248.


Usage
-----

    $ tomdoc file.rb
    # Prints colored documentation of file.rb.

    $ tomdoc file.rb -n STRING
    # Prints methods or classes in file.rb matching STRING.

    $ tomdoc fileA.rb fileB.rb ...
    # Prints colored documentation of multiple files.

    $ tomdoc -f html file.rb
    # Prints HTML documentation of file.rb.

    $ tomdoc -i file.rb
    # Ignore TomDoc validation, print any methods we find.

    $ tomdoc -l file.rb
    # Lint (validate) the TomDoc in a file.

    $ tomdoc -h
    # Displays more options.


Ruby API
--------

Fully TomDoc'd. Well, it will be.

For now:

    $ tomdoc lib/tomdoc/source_parser.rb


Screenshots
-----------

    tomdoc lib/tomdoc/source_parser.rb -n token

![pattern](http://img.skitch.com/20100408-mnyxuxb4xrrg5x4pnpsmuth4mu.png)

    tomdoc -f html lib/tomdoc/source_parser.rb | browser

or

    tomdoc -f html lib/tomdoc/source_parser.rb > doc.html
    open doc.html

![html](http://img.skitch.com/20100408-dbhtc4mef2q3ygmn63csxgh14w.png)

[man]: https://github.com/defunkt/tomdoc/blob/tomdoc.rb/man/tomdoc.5.ronn
[spec]: https://github.com/defunkt/tomdoc/blob/tomdoc.rb/tomdoc.md
