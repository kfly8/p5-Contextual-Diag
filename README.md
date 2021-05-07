[![Actions Status](https://github.com/kfly8/p5-Contextual-Diag/workflows/test/badge.svg)](https://github.com/kfly8/p5-Contextual-Diag/actions) [![Coverage Status](https://img.shields.io/coveralls/kfly8/p5-Contextual-Diag/master.svg?style=flat)](https://coveralls.io/r/kfly8/p5-Contextual-Diag?branch=master) [![MetaCPAN Release](https://badge.fury.io/pl/Contextual-Diag.svg)](https://metacpan.org/release/Contextual-Diag)
# NAME

Contextual::Diag - diagnose contexts

# SYNOPSIS

```perl
use Contextual::Diag;

if (whatcontext) { }
# => evaluated as BOOL in SCALAR context

my $h = { key => whatcontext 'hello' };
# => wanted LIST context
```

# DESCRIPTION

Contextual::Diag is ...

# LICENSE

Copyright (C) kfly8.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

kfly8 <kfly@cpan.org>
