use strict;
use Test::More;

{

    package MyTest;
    use Moose;
    use MooseX::Aliases;

    has foo => (
        is      => 'rw',
        alias   => 'bar',
        trigger => sub { ::pass('foo') },
    );

    has baz => (
        is      => 'rw',
        alias   => [qw/quux quuux/],
        trigger => sub { ::pass('baz') },
    );

}

ok( my $t = MyTest->new );
$t->foo(1);
$t->bar(1);
$t->baz(1);
$t->quux(1);
$t->quuux(1);
done_testing;
