package Contextual::Diag::Value;
use 5.010;
use strict;
use warnings;

our $VERSION = "0.02";

use Scalar::Util ();

my %DATA;
my %OVERLOAD;

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

BEGIN {
    my %CONTEXT_MAP = (
        q{""}  => 'STR',
        '0+'   => 'NUM',
        'bool' => 'BOOL',
        '${}'  => 'SCALARREF',
        '@{}'  => 'ARRAYREF',
        '&{}'  => 'CODEREF',
        '%{}'  => 'HASHREF',
        '*{}'  => 'GLOBREF',
    );

    %OVERLOAD = map {
        my $context = $CONTEXT_MAP{$_};

        $_ => sub {
            my $self = shift;

            my $id    = Scalar::Util::refaddr $self;
            my $data  = $DATA{$id};
            my $code  = $data->{overload}->{$context};
            my $value = $data->{value};
            return $code->($value);
        }
    } keys %CONTEXT_MAP,
}

use overload %OVERLOAD, fallback => 1;

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
