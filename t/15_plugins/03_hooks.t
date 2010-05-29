use strict;
use warnings;
use Test::More 'import' => ['!pass'], tests => 5;

use Dancer ':syntax';
use Dancer::Plugin;

use t::lib::TestUtils;
use t::lib::TestHooks;

use HTTP::Request;

# before_dispatch hook
my $tests = [
    {method => 'GET',  expected => 'text/html'},
    {method => 'POST', expected => 'application/json'}
];

foreach (@$tests) {
    my $request = HTTP::Request->new($_->{method} => '/');
    Dancer::SharedData->request($request);

    Dancer::Plugin->run_hook('before_dispatch', $request);

    is $request->header('Content-Type'), $_->{expected},
      'content type set in plugin';
}

# after_dispatch hook
my $response = Dancer::Response->new(
    status  => 200,
    content => 'this is the result'
);
Dancer::Plugin->run_hook('after_dispatch', $response);
is $response->{content}, 'TLUSER EHT SI SIHT', 'content ok';

# before_template hook
my $tokens = {foo => 'testing before_template'};
Dancer::Plugin->run_hook('before_template', $tokens);
is $tokens->{foo}, 'etalpmet_erofeb gnitset', 'tokens updated';

# check hook position
eval {
    add_hook('anywhere', sub {'foo'});
};
like $@, qr/unrecognized/, "anywhere is not a valid hook position";
