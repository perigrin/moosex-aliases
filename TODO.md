## TODO

1. Subsume MooseX::MultiInitArgs, make it so that init_arg can take an ArrayRef

    has foo => (
        init_arg => [qw(foo bar baz)],
    )
