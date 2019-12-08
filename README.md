# NAME

Contextual::Diag - diagnose contexts

# SYNOPSIS

    use Contextual::Diag;

    if (whatcontext) { }
    # => evaluated as BOOL in SCALAR context

    my $h = { key => whatcontext 'hello' };
    # => wanted LIST context

# DESCRIPTION

Contextual::Diag is ...

# LICENSE

Copyright (C) kfly8.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

kfly8 <kfly@cpan.org>
