use strict;
use warnings;
use Dancer::Plugin;

add_hook 'before_dispatch' => sub {
    my ($request) = shift;
    $request->header( 'Content-Type' => 'text/html' );
};

add_hook 'before_template' => sub {
    my ( $view, $tokens ) = shift;
    print "on est pas la\n";
};

add_hook 'after_dispatch' => sub {
    my ($response) = shift;
    $response->{content} = 'foo';
};

add_hook 'after_dispatch' => sub {
    my ($response) = shift;
    $response->{content} = uc( $response->{content} );
};

1;
