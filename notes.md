# Notes

These notes are intended simply for my own use.

## Bang bluffs

If a bang bluff is called for a bluff that isn't persistable an error should be thrown.

If the bluff is persistable, all persistable associations within the bluffed object should
be persisted within a transaction (persisting from the inside out).


## Block argument reflection

Can use code from merb to reflect on expected block arguments and default values

```
require 'rubygems'
require 'merb'

include GetArgs

def foo(bar, zed=42)
end

method(:foo).get_args # => [[[:bar], [:zed, 42]], [:zed]]
```

Sourcify is another option but doesn't seem to support blocks with default arguments

Also have Proc#parameters but it doesn't look like it tells you what the default argument value is reported.


If we can find a way to do this we can loosen up the single-argument bluff restriction. Only bluffs without
predefined arguments and bluffs with a hash as the first argument will be given special treatment.

