use strict;
use warnings;
use Dancer::Plugin;

add_hook 'before_dispatch' => sub {
    my ($request) = shift;
    if ($request->method eq 'GET') {
        $request->header('Content-Type' => 'text/html');
    }
    else {
        $request->header('Content-Type' => 'application/json');
    }
};

add_hook 'after_dispatch' => sub {
    my ($response) = shift;
    $response->{content} = _reverse_string($response->{content});
};

add_hook 'after_dispatch' => sub {
    my ($response) = shift;
    $response->{content} = uc( $response->{content} );
};

add_hook 'before_template' => sub {
    my ($tokens) = shift;
    $tokens->{foo} = _reverse_string($tokens->{foo});
};

sub _reverse_string {
    join('', reverse split('', $_[0]));
}

1;
