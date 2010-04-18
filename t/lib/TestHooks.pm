package t::lib::TestHooks;

use Dancer;
use Data::Dumper;
use t::lib::Hooker;

get '/' => sub {
    "Hello, this is the home"
};

1;
