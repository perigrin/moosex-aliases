use strict;
use Test::More;

{
    package MyTest;
    use Moose;
    use MooseX::Aliases;

    has foo => (
        is    => 'ro',
        alias => 'bar',
    );

    has baz => (
        is    => 'ro',
        alias => [qw/quux quuux/],
    );
}

ok(my $t = MyTest->new);
$t->foo;
$t->bar;
$t->baz;
$t->quux;
$t->quuux;
done_testing;
