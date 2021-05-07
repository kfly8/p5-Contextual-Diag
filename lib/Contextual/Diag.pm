package Contextual::Diag;
use 5.010;
use strict;
use warnings;

our $VERSION = "0.01";

use Exporter;
our @ISA = qw/Exporter/;
our @EXPORT = qw/whatcontext/;

use Contextual::Return;
use Carp qw/carp/;


sub whatcontext {

    # XXX: SCALAR block is lazy.
    if (defined wantarray && !wantarray) {
        _carp('wanted SCALAR context');
    }

    return
        VOID     { _carp('wanted VOID context'); @_ }
        LIST     { _carp('wanted LIST context'); @_ }

        # Scalar Value
        BOOL     { _carp('evaluated as BOOL in SCALAR context'); $_[0] }
        NUM      { _carp('evaluated as NUM in SCALAR context');  $_[0] || 0   }
        STR      { _carp('evaluated as STR in SCALAR context');  $_[0] || ""  }

        # Scalar Reference
        SCALARREF { _carp('scalar ref is evaluated as SCALARREF'); defined $_[0] ? $_[0] : \"" }
        ARRAYREF  { _carp('scalar ref is evaluated as ARRAYREF');  defined $_[0] ? $_[0] : [] }
        HASHREF   { _carp('scalar ref is evaluated as HASHREF');   defined $_[0] ? $_[0] : {} }
        CODEREF   { _carp('scalar ref is evaluated as CODEREF');   defined $_[0] ? $_[0] : sub { } }
        GLOBREF   { _carp('scalar ref is evaluated as GLOBREF');   defined $_[0] ? $_[0] : do { no strict qw/refs/; my $package = __PACKAGE__; \*{$package} } }
        OBJREF    { _carp('scalar ref is evaluated as OBJREF');    defined $_[0] ? $_[0] : bless {}, __PACKAGE__ }
    ;
}

sub _carp {
    local $Carp::CarpLevel = 2;
    carp @_;
}

1;
__END__

=encoding utf-8

=head1 NAME

Contextual::Diag - diagnose contexts

=head1 SYNOPSIS

    use Contextual::Diag qw(whatcontext);

    if (whatcontext) { }
    # => warn "evaluated as BOOL in SCALAR context"

    my $h = { key => whatcontext 'hello' };
    # => warn "wanted LIST context"

=head1 DESCRIPTION

Contextual::Diag explains how contexts are evaluated in Perl,
and is intended to help newcomers to the language learn,
since Perl contexts are a unique feature of the language.

=head2 whatcontext()

    whatcontext(@_) => @_

By plugging in the context where you want to know, indicate what the context:

    # CASE: wanted LIST context
    my @t = whatcontext qw/a b/
    my @t = ('a','b', whatcontext())

    # CASE: wanted SCALAR context
    my $t = whatcontext "hello"
    scalar whatcontext qw/a b/

=head1 LICENSE

Copyright (C) kfly8.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

kfly8 E<lt>kfly@cpan.orgE<gt>

=cut

