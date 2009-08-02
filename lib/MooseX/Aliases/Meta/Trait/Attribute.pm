package MooseX::Aliases::Meta::Trait::Attribute;
use Moose::Role;
use Moose::Util::TypeConstraints;
Moose::Util::meta_attribute_alias 'Aliased';

subtype 'MooseX::Aliases::ArrayRef', as 'ArrayRef[Str]';
coerce  'MooseX::Aliases::ArrayRef', from 'Str', via { [$_] };

has alias => (
    is         => 'ro',
    isa        => 'MooseX::Aliases::ArrayRef',
    auto_deref => 1,
    coerce     => 1,
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

no Moose::Role;

1;
__END__
