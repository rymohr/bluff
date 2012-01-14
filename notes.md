# Notes

These notes are intended simply for my own use.

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

Also have Proc#parameters but it doesn't look like it tells you what the default argument value is

