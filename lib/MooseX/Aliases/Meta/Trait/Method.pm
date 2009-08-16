package MooseX::Aliases::Meta::Trait::Method;
use Moose::Role;

=head1 NAME

MooseX::Aliases::Meta::Trait::Method - method metaclass trait for
L<MooseX::Aliases>

=head1 DESCRIPTION

This trait adds an attribute to metaclasses of aliased methods, to track which method they were aliased from.

=cut

=head1 METHODS

=cut

=head2 aliased_from

Returns the name of the method that this method is an alias of.

=cut

has aliased_from => (
    is  => 'ro',
    isa => 'Str',
);

no Moose::Role;

=head1 AUTHOR

  Jesse Luehrs <doy at tozt dot net>

  Chris Prather (chris@prather.org)

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2009 by Jesse Luehrs.

This is free software; you can redistribute it and/or modify it under
the same terms as perl itself.

=cut

1;
