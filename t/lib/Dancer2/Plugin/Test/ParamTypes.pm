package Dancer2::Plugin::Test::ParamTypes;
use strict;
use warnings;

use Dancer2::Plugin;

sub BUILD {
    my $self = shift;

    my ( $daddy ) = grep { ref eq 'Dancer2::Plugin::ParamTypes' } 
                         @{ $self->app->plugins }
        or return warn "plugin ",  __PACKAGE__,
                " needs plugin Dancer2::Plugin::ParamTypes to be loaded";

    $daddy->register_type_check(
        'Int' => sub { Scalar::Util::looks_like_number( $_[0] ) },
    );
}

1;
