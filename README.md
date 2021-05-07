[![Actions Status](https://github.com/kfly8/p5-Contextual-Diag/workflows/test/badge.svg)](https://github.com/kfly8/p5-Contextual-Diag/actions) [![Coverage Status](https://img.shields.io/coveralls/kfly8/p5-Contextual-Diag/master.svg?style=flat)](https://coveralls.io/r/kfly8/p5-Contextual-Diag?branch=master) [![MetaCPAN Release](https://badge.fury.io/pl/Contextual-Diag.svg)](https://metacpan.org/release/Contextual-Diag)
# NAME

Contextual::Diag - diagnose contexts

# SYNOPSIS

```perl
use Contextual::Diag qw(whatcontext);

if (whatcontext) { }
# => warn "evaluated as BOOL in SCALAR context"

my $h = { key => whatcontext 'hello' };
# => warn "wanted LIST context"
```

# DESCRIPTION

Contextual::Diag explains how contexts are evaluated in Perl,
and is intended to help newcomers to the language learn,
since Perl contexts are a unique feature of the language.

# FUNCTIONS

## whatcontext

By plugging in the context where you want to know, indicate what the context:

```perl
# CASE: wanted LIST context
my @t = whatcontext qw/a b/
my @t = ('a','b', whatcontext())

# CASE: wanted SCALAR context
my $t = whatcontext "hello"
scalar whatcontext qw/a b/
```

# LICENSE

Copyright (C) kfly8.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

kfly8 <kfly@cpan.org>
