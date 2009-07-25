package MooseX::Aliases;
use strict;
our $VERSION = '0.01';

use Moose();
use Moose::Exporter;
use Moose::Util::MetaRole;

Moose::Exporter->setup_import_methods( with_caller => ['alias'], );

sub alias {
    my ( $caller, $orig, $alias ) = @_;
    my $meta   = Class::MOP::class_of($caller);
    my $method = $meta->find_method_by_name($orig);
    Moose::confess "cannot find method $orig to alias" unless $method;
    $meta->add_method( $alias => $method );
}

sub init_meta {
    shift;
    my %options = @_;
    Moose->init_meta(%options);
    Moose::Util::MetaRole::apply_metaclass_roles(
        for_class               => $options{for_class},
        attribute_metaclass_roles =>
            ['MooseX::Aliases::Meta::Trait::Attribute'],
    );
    return Class::MOP::class_of($options{for_class});
}

1;

__END__

=head1 NAME

MooseX::Aliases - A module for easy aliasing of methods and attributes in Moose.

=head1 VERSION

This documentation refers to version 0.01.

=head1 SYNOPSIS

    package MyApp;
    use Moose;
    use MooseX::Aliases;
    
    has this => ( 
        isa   => 'Str',
        is    => 'rw',
        alias => 'that',
    );
    
    sub foo { say $self->that }
    alias foo => 'bar';
    
    $o = MyApp->new();
    $o->this('Hello World');
    $o->bar; # prints 'Hello World'

=head1 DESCRIPTION

The MooseX::Aliases module will allow you to quickly alias methods in Moose.
It provides an alias parameter for has() to generate aliased accessors as well
as the standard ones.

=head1 EXPORTED FUNCTIONS 

=head2 alias Str $original Str $alias

Alias the method $original to the method $alias

=head1 DEPENDENCIES

Moose

=head1 BUGS AND LIMITATIONS

None known currently, please email the author if you find any.

=head1 AUTHOR

Chris Prather (chris@prather.org)

Jesse Luehrs (doy at tozt dot net)

=head1 LICENCE

Copyright 2009 by Chris Prather.

This software is free.  It is licensed under the same terms as Perl itself.

=cut
