#!/usr/bin/env perl
use strict;
use warnings;
use Test::More tests => 1;

package Foo;
use Moose;
::use_ok('MooseX::Aliases')
    or ::BAIL_OUT("couldn't load MooseX::Aliases");
