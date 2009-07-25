use strict;
use Test::More;

my $called;

{

    package MyTestRole;
    use Moose::Role;
    use MooseX::Aliases;

    has foo => (
        is      => 'rw',
        alias   => 'bar',
        trigger => sub { $called++ },
    );

    has baz => (
        is      => 'rw',
        alias   => [qw/quux quuux/],
        trigger => sub { $called++ },
    );

    sub run { $called++ }
    alias walk => 'foo';
}

{

    package MyTest;
    use Moose;
    with 'MyTestRole';
}

ok( my $t = MyTest->new );
$t->foo(1);
$t->bar(1);
$t->baz(1);
$t->quux(1);
$t->quuux(1);
$t->run;
$t->walk;
is( $called, 7, 'all aliased methods were called' );
done_testing;
