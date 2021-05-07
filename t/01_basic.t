use Test2::V0;

use Contextual::Diag;

subtest 'VOID context' => sub {
    my $expected = [
        qr/^wanted VOID context/,
    ];
    like( warnings { whatcontext }, $expected );
};

subtest 'LIST context' => sub {
    my $expected = [
        qr/^wanted LIST context/,
    ];
    like( warnings { my @t = whatcontext }, $expected );
    like( warnings { my %t = whatcontext }, $expected, 'Assignment LIST as HASH' );
    like( warnings { for(whatcontext()) { } }, $expected, 'for statement' );
    like( warnings { my @t = ('a','b', whatcontext()) }, $expected, 'list elements' );
    like( warnings { my %h = (key => whatcontext('a')) }, $expected, 'hash value' );
    like( warnings { my $h = {key => whatcontext('a')} }, $expected, 'hashref value' );
    like( warnings { (sub {})->(whatcontext()) }, $expected, 'sub arguments' );
    like( warnings { sort(whatcontext()) }, $expected, 'sort function' );
    like( warnings { my ($t) = whatcontext }, $expected, 'assignment LIST as list' );
};

subtest 'SCALAR context' => sub {
    my $expected = [
        qr/^wanted SCALAR context/,
    ];
    like( warnings { my $t = whatcontext }, $expected );
    like( warnings { scalar whatcontext() }, $expected );
};

subtest 'SCALAR as BOOL' => sub {
    my $expected = [
        qr/^wanted SCALAR context/,
        qr/^evaluated as BOOL in SCALAR context/,
    ];
    like( warnings { if (whatcontext) {} }, $expected );
};

subtest 'SCALAR as STR' => sub {
    my $expected = [
        qr/^wanted SCALAR context/,
        qr/^evaluated as STR in SCALAR context/,
    ];

    like( warnings { ok "hello" ne whatcontext }, $expected );
    like( warnings { ok "hello" eq whatcontext "hello" }, $expected );
    like( warnings { length whatcontext() }, $expected );
};

subtest 'SCALAR as NUM' => sub {
    my $expected = [
        qr/^wanted SCALAR context/,
        qr/^evaluated as NUM in SCALAR context/,
    ];

    like( warnings { ok 1 != whatcontext }, $expected );
    like( warnings { ok 1 == whatcontext 1 }, $expected );
};

subtest 'evaluated as SCALARREF' => sub {
    my $expected = [
        qr/^wanted SCALAR context/,
        qr/^scalar ref is evaluated as SCALARREF/,
    ];
    like( warnings { my $t = ${whatcontext()} }, $expected );
    like( warnings { my $t = ${whatcontext(\"hoge")} }, $expected );
};

subtest 'evaluated as ARRAYREF' => sub {
    my $expected = [
        qr/^wanted SCALAR context/,
        qr/^scalar ref is evaluated as ARRAYREF/,
    ];
    like( warnings { my $t = @{whatcontext()} }, $expected );
    like( warnings { my $t = @{whatcontext(["a"])} }, $expected );
    like( warnings { whatcontext()->[0] }, $expected, 'access to element of arrrayref' );
};

subtest 'evaluated as HASHREF' => sub {
    my $expected = [
        qr/^wanted SCALAR context/,
        qr/^scalar ref is evaluated as HASHREF/,
    ];
    like( warnings { my $t = %{whatcontext()} }, $expected );
    like( warnings { my $t = %{whatcontext({"key" => "value"})} }, $expected );
    like( warnings { whatcontext()->{somekey} }, $expected, 'access to element of hashref' );
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
    like( warnings { *{whatcontext()}->{CODE} }, $expected );
    like( warnings { *{whatcontext($globref)}->{CODE} }, $expected );
};

subtest 'evaluated as CODEREF' => sub {
    my $expected = [
        qr/^wanted SCALAR context/,
        qr/^scalar ref is evaluated as CODEREF/,
    ];
    like( warnings { whatcontext()->() }, $expected );
    like( warnings { whatcontext(sub {})->() }, $expected );
};

subtest 'evaluated as OBJREF' => sub {
    my $expected = [
        qr/^wanted SCALAR context/,
        qr/^scalar ref is evaluated as OBJREF/,
    ];
    my $obj = bless {}, 'Some';
    like( warnings { whatcontext()->can('somemethod') }, $expected );
    like( warnings { whatcontext($obj)->can('somemethod') }, $expected );
};

done_testing;
