use strict;
use warnings;
use Dancer::Plugin;

use YAML::Syck;

add_handler 'before_dispatch' => sub {
    my ($request) = shift;
    $request->header('Content-Type' => 'text/html');
};

add_handler 'before_template' => sub {
    my ($view, $tokens) = shift;
    print "on est pas la\n";
};

add_handler 'after_dispatch' => sub {
    my ($response) = shift;
    $response->{content} = 'foo';
};

add_handler 'after_dispatch' => sub {
    my ($response) = shift;
    $response->{content} = uc($response->{content});
};

1;
