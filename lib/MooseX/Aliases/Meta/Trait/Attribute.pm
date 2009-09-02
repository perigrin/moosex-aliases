package MooseX::Aliases::Meta::Trait::Attribute;
use Moose::Role;
use Moose::Util::TypeConstraints;
Moose::Util::meta_attribute_alias 'Aliased';

=head1 NAME

MooseX::Aliases::Meta::Trait::Attribute - attribute metaclass trait for L<MooseX::Aliases>

=head1 SYNOPSIS

    package MyApp::Role;
    use Moose::Role;
    use MooseX::Aliases;

    has this => (
        isa   => 'Str',
        is    => 'rw',
        traits => [qw(Aliased)],
        alias => 'that',
    );

=head1 DESCRIPTION

This trait adds the C<alias> option to attribute creation. It is automatically
applied to all attributes when C<use MooseX::Aliases;> is run, but must be
explicitly applied in roles, due to issues with Moose's handling of attributes
in roles.

=cut

subtype 'MooseX::Aliases::ArrayRef', as 'ArrayRef[Str]';
coerce  'MooseX::Aliases::ArrayRef', from 'Str', via { [$_] };

has alias => (
    is         => 'ro',
    isa        => 'MooseX::Aliases::ArrayRef',
    auto_deref => 1,
    coerce     => 1,
    predicate  => 'has_alias',
);

after install_accessors => sub {
    my $self = shift;
    my $class_meta = $self->associated_class;
    my $orig_name  = $self->get_read_method;
    my $orig_meth  = $self->get_read_method_ref;
    for my $alias ($self->alias) {
        $class_meta->add_method(
            $alias => MooseX::Aliases::_get_method_metaclass($orig_meth)->wrap(
                $orig_meth,
                name         => $alias,
                aliased_from => $orig_name,
            )
        );
    }
};

around initialize_instance_slot => sub {
    my $orig = shift;
    my $self = shift;
    my ($meta_instance, $instance, $params) = @_;

    if ($self->has_alias && (!$self->has_init_arg || defined $self->init_arg)) {
        if(my @aliases = grep { exists $params->{$_} } @{ $self->alias }) {
            if ($self->has_init_arg and exists $params->{ $self->init_arg }) {
                push(@aliases, $self->init_arg);
            }

            confess 'Conflicting init_args: (' . join(', ', @aliases) . ')' if @aliases > 1;
            $self->_set_initial_slot_value($meta_instance, $instance, $params->{$aliases[0]});
        }
    }
    $self->$orig(@_);
};

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
