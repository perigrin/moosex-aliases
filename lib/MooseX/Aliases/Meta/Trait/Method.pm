package MooseX::Aliases::Meta::Trait::Method;
use Moose::Role;

has aliased_from => (
    is  => 'ro',
    isa => 'Str',
);

no Moose::Role;

1;
