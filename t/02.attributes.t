use strict;
use Test::More;

my $called;

{

    package MyTest;
    use Moose;
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

}

ok( my $t = MyTest->new );
$t->foo(1);
$t->bar(1);
$t->baz(1);
$t->quux(1);
$t->quuux(1);
is($called, 5, 'all aliased methods were called');
done_testing;
