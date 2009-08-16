#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;

my $called = 0;

{
    package MyTest;
    use Moose;
    use MooseX::Aliases;

    sub foo { $called++ }
    alias foo => 'bar';
}

my $t = MyTest->new;
$t->foo;
$t->bar;
is($called, 2, 'alias calls the original method');
done_testing;
