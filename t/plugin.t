#!/usr/bin/perl
use strict;
use warnings;
use lib 't/lib';
use Test::More 'tests' => 1;
use t::lib::Utils;
use Plack::Test;
use HTTP::Request::Common;

## no critic qw(Subroutines::ProhibitCallsToUndeclaredSubs)

{
    package MyApp;
    use Dancer2;

    use Dancer2::Plugin::ParamTypes;
    use Dancer2::Plugin::Test::ParamTypes;

    # you could also have a shortcut of the form
    # use Dancer2::Plugin::ParamTypes libraries => [qw/
    #       +Dancer2::Plugin::Test::ParamTypes
    #       Default   <-- would resolve into Dancer2::Plugin::ParamTypes::Default, natch
    # /]

    get '/' => with_types [
        [ 'query', 'id', 'Int' ],
    ] => sub { return 'query'; };
}

my $test = Plack::Test->create( MyApp->to_app );

subtest 'Use type checks from plugin' => sub {
    successful_test( $test, GET('/?id=30'), 'query' );
    missing_test( $test, GET('/'), 'query', 'id' );
    failing_test( $test, GET('/?id=k'), 'query', 'id', 'Int' );
};
