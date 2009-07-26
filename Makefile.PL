use inc::Module::Install;

name 'MooseX-Aliases';
all_from 'lib/MooseX/Aliases.pm';

requires Class-MOP => 0.91;
requires Moose => 0.89;

WriteAll;
