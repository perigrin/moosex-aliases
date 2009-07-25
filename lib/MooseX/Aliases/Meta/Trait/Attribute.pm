package MooseX::Aliases::Meta::Trait::Attribute;
use Moose::Role;
use Moose::Util::TypeConstraints;

subtype 'MooseX::Aliases::ArrayRef', as 'ArrayRef[Str]';
coerce 'MooseX::Aliases::ArrayRef', from 'Str', via { [$_] };

has alias => (
    is         => 'ro',
    isa        => 'MooseX::Aliases::ArrayRef',
    auto_deref => 1,
    coerce     => 1,
);

after install_accessors => sub {
    my $self = shift;
    for my $alias ( $self->alias ) {
        MooseX::Aliases::alias( $self->associated_class->name,
            $self->get_read_method => $alias, );
    }
};
no Moose::Role;

package Moose::Meta::Attribute::Custom::Trait::Aliased;
sub register_implementation { 'MooseX::Aliases::Meta::Trait::Attribute' }

1;
__END__
