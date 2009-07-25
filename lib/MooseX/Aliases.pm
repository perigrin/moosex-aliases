package MooseX::Aliases;
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