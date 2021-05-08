package Contextual::Diag;
use 5.010;
use strict;
use warnings;

our $VERSION = "0.02";

use Exporter;
our @ISA = qw/Exporter/;
our @EXPORT = qw/contextual_diag/;

use Contextual::Return;
use Carp ();

sub contextual_diag {

    # XXX: SCALAR block is lazy.
    # https://metacpan.org/pod/Contextual%3A%3AReturn#Lazy-contextual-return-values
    if (defined wantarray && !wantarray) {
        _diag('wanted SCALAR context');
    }

    return
        VOID     { _diag('wanted VOID context'); @_ }
        LIST     { _diag('wanted LIST context'); @_ }

        # Scalar Value
        BOOL     { _diag('evaluated as BOOL in SCALAR context'); $_[0] }
        NUM      { _diag('evaluated as NUM in SCALAR context');  $_[0] || 0   }
        STR      { _diag('evaluated as STR in SCALAR context');  $_[0] || ""  }

        # Scalar Reference
        SCALARREF { _diag('scalar ref is evaluated as SCALARREF'); defined $_[0] ? $_[0] : \"" }
        ARRAYREF  { _diag('scalar ref is evaluated as ARRAYREF');  defined $_[0] ? $_[0] : [] }
        HASHREF   { _diag('scalar ref is evaluated as HASHREF');   defined $_[0] ? $_[0] : {} }
        CODEREF   { _diag('scalar ref is evaluated as CODEREF');   defined $_[0] ? $_[0] : sub { } }
        GLOBREF   { _diag('scalar ref is evaluated as GLOBREF');   defined $_[0] ? $_[0] : do { no strict qw/refs/; my $package = __PACKAGE__; \*{$package} } }
        OBJREF    { _diag('scalar ref is evaluated as OBJREF');    defined $_[0] ? $_[0] : bless {}, __PACKAGE__ }
    ;
}

sub _diag {
    local $Carp::CarpLevel = 2;
    goto &Carp::carp;
}

1;
__END__

=encoding utf-8

=head1 NAME

Contextual::Diag - diagnosing perl context

=head1 SYNOPSIS

    use Contextual::Diag;

    if (contextual_diag) { }
    # => warn "evaluated as BOOL in SCALAR context"

    my $h = { key => contextual_diag 'hello' };
    # => warn "wanted LIST context"

=head1 DESCRIPTION

Contextual::Diag is a tool for diagnosing perl context.
The purpose of this module is to make it easier to learn perl context.

=head2 contextual_diag()

    contextual_diag(@_) => @_

By plugging in the context where you want to know, indicate what the context:

    # CASE: wanted LIST context
    my @t = contextual_diag qw/a b/
    my @t = ('a','b', contextual_diag())

    # CASE: wanted SCALAR context
    my $t = contextual_diag "hello"
    scalar contextual_diag qw/a b/

=head1 LICENSE

Copyright (C) kfly8.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

kfly8 E<lt>kfly@cpan.orgE<gt>

=cut

