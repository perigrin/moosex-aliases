package MooseX::Aliases;

use Moose ();
use Moose::Exporter;
use Moose::Util::MetaRole;
use MooseX::Aliases::Meta::Trait::Attribute;
use Scalar::Util qw(blessed);

Moose::Exporter->setup_import_methods( with_caller => ['alias'] );

sub _get_method_metaclass {
    my ($method) = @_;

    my $meta = Class::MOP::class_of($method);
    if ($meta->can('does_role')
     && $meta->does_role('MooseX::Aliases::Meta::Trait::Method')) {
        return blessed($method);
    }
    else {
        return Moose::Meta::Class->create_anon_class(
            superclasses => [blessed($method)],
            roles        => ['MooseX::Aliases::Meta::Trait::Method'],
            cache        => 1,
        )->name;
    }
}

sub alias {
    my ( $caller, $orig, $alias ) = @_;
    my $meta   = Class::MOP::class_of($caller);
    my $method = $meta->find_method_by_name($orig);
    Moose->throw_error("cannot find method $orig to alias") unless $method;
    $meta->add_method(
        $alias => _get_method_metaclass($method)->wrap(
            $method,
            aliased_from => $orig
        )
    );
}

sub init_meta {
    shift;
    my %options = @_;
    Moose::Util::MetaRole::apply_metaclass_roles(
        for_class                 => $options{for_class},
        attribute_metaclass_roles =>
            ['MooseX::Aliases::Meta::Trait::Attribute'],
    );
    return Class::MOP::class_of($options{for_class});
}

1;

__END__

=head1 NAME

MooseX::Aliases - A module for easy aliasing of methods and attributes in Moose.

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

or 

    package MyApp::Role;
    use Moose::Role;
   
    has this => ( 
        isa   => 'Str',
        is    => 'rw',
        traits => [qw(Aliased)],
        alias => 'that',
    );
    
    sub foo { say $self->that }
    alias foo => 'bar';

=head1 DESCRIPTION

The MooseX::Aliases module will allow you to quickly alias methods in Moose.
It provides an alias parameter for has() to generate aliased accessors as well
as the standard ones.

=head1 EXPORTED FUNCTION 

=head2 alias Str $original Str $alias

Alias the method $original to the method $alias

=head1 DEPENDENCIES

Moose

=head1 BUGS AND LIMITATIONS

Currently if you're using MooseX::Aliased in a Role you will need to
explicitly associate the Metaclass trait with your attribute. This is because
Moose won't automatically apply metaclass traits to attributes in Roles. The
example in the Synopsis should work.

=head1 AUTHOR

Chris Prather (chris@prather.org)

Jesse Luehrs (doy at tozt dot net)

=head1 LICENCE

Copyright 2009 by Chris Prather.

This software is free.  It is licensed under the same terms as Perl itself.

=cut
