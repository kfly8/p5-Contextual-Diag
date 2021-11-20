use Test2::V0;

use Contextual::Diag;
use CDD;

subtest 'VOID context' => sub {
    my $expected = [
        qr/^wanted VOID context/,
    ];
    like( warnings { contextual_diag }, $expected );
};

subtest 'LIST context' => sub {
    my $expected = [
        qr/^wanted LIST context/,
    ];
    like( warnings { my @t = contextual_diag }, $expected );
    like( warnings { my @t = contextual_diag qw/a b/ }, $expected );
    like( warnings { my %t = contextual_diag }, $expected, 'Assignment LIST as HASH' );
    like( warnings { for(contextual_diag()) { } }, $expected, 'for statement' );
    like( warnings { my @t = ('a','b', contextual_diag()) }, $expected, 'list elements' );
    like( warnings { my %h = (key => contextual_diag('a')) }, $expected, 'hash value' );
    like( warnings { my $h = {key => contextual_diag('a')} }, $expected, 'hashref value' );
    like( warnings { (sub {})->(contextual_diag()) }, $expected, 'sub arguments' );
    like( warnings { sort(contextual_diag()) }, $expected, 'sort function' );
    like( warnings { my ($t) = contextual_diag }, $expected, 'assignment LIST as list' );
};

subtest 'SCALAR context' => sub {
    my $expected = [
        qr/^wanted SCALAR context/,
    ];
    like( warnings { my $t = contextual_diag }, $expected );
    like( warnings { scalar contextual_diag() }, $expected );
    like( warnings { scalar contextual_diag qw/a b/ }, $expected );
};

subtest 'SCALAR as BOOL' => sub {
    my $expected = [
        qr/^wanted SCALAR context/,
        qr/^evaluated as BOOL in SCALAR context/,
    ];
    like( warnings { if (contextual_diag) {} }, $expected );
};

subtest 'SCALAR as STR' => sub {
    my $expected = [
        qr/^wanted SCALAR context/,
        qr/^evaluated as STR in SCALAR context/,
    ];

    like( warnings { ok "hello" ne contextual_diag }, $expected );
    like( warnings { ok "" eq contextual_diag }, $expected );
    like( warnings { length contextual_diag() }, $expected );
};

subtest 'SCALAR as NUM' => sub {
    my $expected = [
        qr/^wanted SCALAR context/,
        qr/^evaluated as NUM in SCALAR context/,
    ];

    like( warnings { ok 1 != contextual_diag }, $expected );
    like( warnings { ok 0 == contextual_diag }, $expected );
};

subtest 'evaluated as SCALARREF' => sub {
    my $expected = [
        qr/^wanted SCALAR context/,
        qr/^scalar ref is evaluated as SCALARREF/,
    ];
    like( warnings { my $t = ${contextual_diag()} }, $expected );
    like( warnings { my $t = ${contextual_diag(\"hoge")} }, $expected );
};

subtest 'evaluated as ARRAYREF' => sub {
    my $expected = [
        qr/^wanted SCALAR context/,
        qr/^scalar ref is evaluated as ARRAYREF/,
    ];
    like( warnings { my $t = @{contextual_diag()} }, $expected );
    like( warnings { my $t = @{contextual_diag(["a"])} }, $expected );
    like( warnings { contextual_diag()->[0] }, $expected, 'access to element of arrrayref' );
};

subtest 'evaluated as HASHREF' => sub {
    my $expected = [
        qr/^wanted SCALAR context/,
        qr/^scalar ref is evaluated as HASHREF/,
    ];
    like( warnings { my $t = %{contextual_diag()} }, $expected );
    like( warnings { my $t = %{contextual_diag({"key" => "value"})} }, $expected );
    like( warnings { contextual_diag()->{somekey} }, $expected, 'access to element of hashref' );
};

subtest 'evaluated as GLOBREF' => sub {
    my $expected = [
        qr/^wanted SCALAR context/,
        qr/^scalar ref is evaluated as GLOBREF/,
    ];
    my $globref = do {
        no strict qw(refs);
        my $package = __PACKAGE__;
        \*{$package};
    };
    like( warnings { *{contextual_diag()}->{CODE} }, $expected );
    like( warnings { *{contextual_diag($globref)}->{CODE} }, $expected );
};

subtest 'evaluated as CODEREF' => sub {
    my $expected = [
        qr/^wanted SCALAR context/,
        qr/^scalar ref is evaluated as CODEREF/,
    ];
    like( warnings { contextual_diag()->() }, $expected );
    like( warnings { contextual_diag(sub {})->() }, $expected );
};

subtest 'evaluated as OBJREF' => sub {
    my $expected = [
        qr/^wanted SCALAR context/,
        qr/^scalar ref is evaluated as OBJREF/,
    ];

    like( warnings { ok !contextual_diag()->can('somemethod') }, $expected );
    like( warnings { ok !contextual_diag()->isa('Some') }, $expected );
};

subtest 'override can/isa' => sub {
    ok(Contextual::Diag::Value->can('new'));
    ok(!Contextual::Diag::Value->can('hoge'));
    ok(Contextual::Diag::Value->isa('Contextual::Diag::Value'));
    ok(Contextual::Diag::Value->isa('UNIVERSAL'));
    ok(!Contextual::Diag::Value->isa('Hoge'));

    like dies {
        Contextual::Diag::Value->hoge;
    }, qr/cannot AUTOLOAD in class call/;
};

subtest 'cdd' => sub {
    like( warnings { cdd }, [qr/^wanted VOID context/] );
    like( warnings { my @t = cdd }, [qr/^wanted LIST context/] );
    like( warnings { my $t = cdd }, [qr/^wanted SCALAR context/ ] );
};

done_testing;
