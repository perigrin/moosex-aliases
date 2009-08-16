#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;

my $called;

{
    package MyTest;
    use Moose;
    use MooseX::Aliases;

    has foo => (
        is      => 'rw',
        traits   => ['Aliased'],
        alias   => 'bar',
        trigger => sub { $called++ },
    );

    has baz => (
        is      => 'rw',
        traits  => ['Aliased'],
        alias   => [qw/quux quuux/],
        trigger => sub { $called++ },
    );

    sub run { $called++ }
    alias run => 'walk';
}

my $t = MyTest->new;
$t->foo(1);
$t->bar(1);
$t->baz(1);
$t->quux(1);
$t->quuux(1);
$t->run;
$t->walk;
is($called, 7, 'all aliased methods were called');
done_testing;
