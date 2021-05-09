package Contextual::Diag::Value;
use 5.010;
use strict;
use warnings;

our $VERSION = "0.02";

use Scalar::Util ();

my %DATA;

sub new {
    my ($class, $value, %overload) = @_;

    # Use inside-out to prevent infinite recursion
    my $self = bless \my $scalar => $class;
    my $id = Scalar::Util::refaddr $self;
    $DATA{$id} = {
        value => $value,
        overload => \%overload,
    };
    return $self;
}

sub _gen_overload {
    my $context = shift;

    return sub {
        my $self = shift;

        my $id    = Scalar::Util::refaddr $self;
        my $data  = $DATA{$id};
        my $code  = $data->{overload}->{$context};
        my $value = $data->{value};
        return $code->($value);
    }
}

use overload 
    q{""}    => _gen_overload('STR'),
    '0+'     => _gen_overload('NUM'),
    'bool'   => _gen_overload('BOOL'),
    '${}'    => _gen_overload('SCALARREF'),
    '@{}'    => _gen_overload('ARRAYREF'),
    '&{}'    => _gen_overload('CODEREF'),
    '%{}'    => _gen_overload('HASHREF'),
    '*{}'    => _gen_overload('GLOBREF'),
    fallback => 1;

sub can {
    my ($invocant) = @_;
    if (ref $invocant) {
        our $AUTOLOAD = 'can';
        goto &AUTOLOAD;
    }
    return $invocant->SUPER::can(@_[1..$#_]);
}

sub isa {
    my ($invocant) = @_;
    if (ref $invocant) {
        our $AUTOLOAD = 'isa';
        goto &AUTOLOAD;
    }
    return $invocant->SUPER::isa(@_[1..$#_]);
}

sub AUTOLOAD {
    my $self = shift;
    our $AUTOLOAD;

    my $obj = do {
        my $id    = Scalar::Util::refaddr $self;
        my $data  = $DATA{$id};
        my $code  = $data->{overload}->{OBJREF};
        my $value = $data->{value};
        my $obj   = $code->($value);
        $obj;
    };

    my ($method) = $AUTOLOAD =~ m{ .* :: (.*) }xms ? $1 : $AUTOLOAD;
    return $obj->$method(@_);
}

sub DESTROY {
    my $self = shift;
    my $id    = Scalar::Util::refaddr $self;
    delete $DATA{$id};
    return;
}

1;
