use Test2::V0;

use Contextual::Diag;

like(
    warnings { if (whatcontext) {} },
    [
        qr/^wanted SCALAR context/,
        qr/^evaluated as BOOL in SCALAR context/,
    ],
    "BOOL"
);

like(
    warnings { if ("hello" eq whatcontext) { } },
    [
        qr/^wanted SCALAR context/,
        qr/^evaluated as STR in SCALAR context/,
    ],
    "STR"
);

like(
    warnings { if (0 == whatcontext) { } },
    [
        qr/^wanted SCALAR context/,
        qr/^evaluated as NUM in SCALAR context/,
    ],
    "NUM"
);

like(
    warning { my $t = whatcontext },
    qr/^wanted SCALAR context/,
    "Assignment SCALAR"
);

like(
    warning { my @t = whatcontext },
    qr/^wanted LIST context/,
    "Assignment LIST as ARRAY"
);

like(
    warning { my %t = whatcontext },
    qr/^wanted LIST context/,
    "Assignment LIST as HASH"
);

like(
    warning { whatcontext },
    qr/^wanted VOID context/,
    "VOID context"
);

like(
    warnings { my $t = ${whatcontext()} },
    [
        qr/^wanted SCALAR context/,
        qr/^scalar ref is evaluated as SCALARREF/,
    ],
    "evaluated as SCALARREF"
);

like(
    warnings { my @t = @{whatcontext()} },
    [
        qr/^wanted SCALAR context/,
        qr/^scalar ref is evaluated as ARRAYREF/,
    ],
    "evaluated as ARRAYREF"
);

like(
    warnings { my %t = %{whatcontext()} },
    [
        qr/^wanted SCALAR context/,
        qr/^scalar ref is evaluated as HASHREF/,
    ],
    "evaluated as ARRAYREF"
);

like(
    warnings { *{whatcontext()}->{CODE} },
    [
        qr/^wanted SCALAR context/,
        qr/^scalar ref is evaluated as GLOBREF/,
    ],
    "evaluated as GLOBREF"
);

like(
    warnings { whatcontext()->[0] },
    [
        qr/^wanted SCALAR context/,
        qr/^scalar ref is evaluated as ARRAYREF/,
    ],
    "evaluated as ARRAYREF when access to element"
);

like(
    warnings { whatcontext()->{somekey} },
    [
        qr/^wanted SCALAR context/,
        qr/^scalar ref is evaluated as HASHREF/,
    ],
    "evaluated as HASHREF when access to element"
);

like(
    warnings { whatcontext()->() },
    [
        qr/^wanted SCALAR context/,
        qr/^scalar ref is evaluated as CODEREF/,
    ],
    "evaluated as CODEREF"
);

like(
    warnings { whatcontext()->can('somemethod') },
    [
        qr/^wanted SCALAR context/,
        qr/^scalar ref is evaluated as OBJREF/,
    ],
    "evaluated as OBJREF"
);

like(
    warning { for(whatcontext()) { } },
    qr/^wanted LIST context/,
    "for statement"
);

like(
    warning { my @t = ('a','b', whatcontext()) },
    qr/^wanted LIST context/,
    "list elements"
);

like(
    warning { my %h = (key => whatcontext('a')) },
    qr/^wanted LIST context/,
    "hash elements"
);

like(
    warning { my $h = {key => whatcontext('a')} },
    qr/^wanted LIST context/,
    "hash ref elements"
);

like(
    warning { (sub {})->(whatcontext()) },
    qr/^wanted LIST context/,
    "sub args"
);

like(
    warning { sort(whatcontext()) },
    qr/^wanted LIST context/,
    "sort function"
);

like(
    warnings { length whatcontext() },
    [
        qr/^wanted SCALAR context/,
        qr/^evaluated as STR in SCALAR context/,
    ],
    "length"
);

like(
    warning { my ($t) = whatcontext },
    qr/^wanted LIST context/,
    "Assignment LIST as list"
);

like(
    warning { my @t = scalar whatcontext(); },
    qr/^wanted SCALAR context/,
    "force scalar context"
);

done_testing;
