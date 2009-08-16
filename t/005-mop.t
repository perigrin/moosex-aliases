#!/usr/bin/env perl
use strict;
use warnings;
use Test::More tests => 4;

{
    package MyTest;
    use Moose;
    use MooseX::Aliases;

    sub foo { }
    alias foo => 'bar';

    has baz => (
        is    => 'ro',
        alias => 'quux',
    );
}

my $method = MyTest->meta->get_method('bar');
ok($method->meta->does_role('MooseX::Aliases::Meta::Trait::Method'),
   'does the method trait');
is($method->aliased_from, 'foo', 'bar is aliased from foo');
my $attr_method = MyTest->meta->get_method('quux');
ok($attr_method->meta->does_role('MooseX::Aliases::Meta::Trait::Method'),
   'does the method trait');
is($attr_method->aliased_from, 'baz', 'quux is aliased from baz');
