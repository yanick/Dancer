use strict;
use warnings;
use Test::More 'import' => ['!pass'], tests => 2;

use Dancer ':syntax';

use t::lib::TestUtils;
use t::lib::TestHooks;

use YAML::Syck;
use HTTP::Request;

my $request = HTTP::Request->new( GET => '/' );
Dancer::SharedData->request($request);

Dancer::Plugin->run_hook( 'before_dispatch', $request );
is $request->header('Content-Type'), 'text/html',
    'content type set in plugin';

my $response = Dancer::Response->new(
    status  => 200,
    content => 'this is the result'
);

Dancer::Plugin->run_hook('after_dispatch', $response);

is $response->{content}, 'FOO', 'content ok';
