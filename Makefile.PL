use inc::Module::Install;

name 'MooseX-Aliases';
all_from 'lib/MooseX/Aliases.pm';

requires Moose => undef;

WriteAll;
