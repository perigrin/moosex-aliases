package MooseX::Aliases;
use strict;
our $VERSION = '0.01';

use Moose();
use Moose::Exporter;

Moose::Exporter->setup_import_methods( with_caller => ['alias'], );

sub alias {
    my ( $caller, $orig, $alias ) = @_;
    my $meta   = Class::MOP::class_of($caller);
    my $method = $meta->find_method_by_name($orig);
    Moose::confess "cannot find method $orig to alias" unless $method;
    $meta->add_method( $alias => $method );
}

1;

__END__

=head1 NAME

MooseX::Aliases - A class to ...

=head1 VERSION

This documentation refers to version 0.01.

=head1 SYNOPSIS

    package MyApp;
    use Moose;
    use MooseX::Aliases;
    
    sub foo { ... }
    alias foo => 'bar';
    
    MyApp->new->bar;

=head1 DESCRIPTION

The MooseX::Aliases class implements ...

=head1 SUBROUTINES / METHODS

=head2 alias Str $original Str $alias

Alias the method $original to the method $alias

=head1 DEPENDENCIES

Moose

=head1 BUGS AND LIMITATIONS

None known currently, please email the author if you find any.

=head1 AUTHOR

Chris Prather (chris@prather.org)

=head1 LICENCE

Copyright 2009 by Chris Prather.

This software is free.  It is licensed under the same terms as Perl itself.

=cut
