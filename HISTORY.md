= Release History

== 0.2.2 | 2011-06-09

Have `tomdoc/tomdoc.rb` require `tomdoc`arg.rb` which it needs.
This is so plugins like yard-tomdoc can require `tomdoc/tomdoc`
without the rest of tomdoc code base.

Changes:

* tomdoc/tomdoc.rb reuqires `tomdoc/arg.rb`.
* fix bug in #tomdoc method clean code.
* remark out clean code for the time being.


== 0.2.1 | 2011-06-08

This release removes unused dependencies from the gem.

Changes:

* Remove unused dependencies for gem.


== 0.2.0 | 2011-05-20

This release addresses a few nagging bugs and a dependency conflict.

Changes:

* Fix Ruby 1.9 issue, use Array#join instead of Array#to_s
* Fix issue #5, undefined instance_methods
* Fix Test namespace reference
* Fix colored gem as dependency in gemspec
* Fix TomDoc#args returns empty array when no arguments are in comment
* Fix dependecy version constraints
 
