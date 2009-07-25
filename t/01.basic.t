use strict;
use Test::More;

{
    package MyTest;
    use Moose;
    use MooseX::Aliases;
    
    sub foo { ::pass('Foo') }
    alias foo => 'bar';
}

ok(my $t = MyTest->new);
$t->foo;
$t->bar;
done_testing;