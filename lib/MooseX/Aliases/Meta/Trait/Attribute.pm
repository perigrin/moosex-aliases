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
    my $class_meta = $self->associated_class;
    my $orig_name   = $self->get_read_method;
    my $orig_method = $self->get_read_method_ref;
    my $method_meta = Moose::Meta::Class->create_anon_class(
        superclasses => [blessed($orig_method)],
        roles        => ['MooseX::Aliases::Meta::Trait::Method'],
        cache        => 1,
    )->name;
    for my $alias ($self->alias) {
        $class_meta->add_method(
            $alias => $method_meta->wrap(
                $orig_method,
                name         => $alias,
                aliased_from => $orig_name,
            )
        );
    }
};
no Moose::Role;

package Moose::Meta::Attribute::Custom::Trait::Aliased;
sub register_implementation { 'MooseX::Aliases::Meta::Trait::Attribute' }

1;
__END__
