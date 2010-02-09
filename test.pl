use lib 'lib';
use Dancer;
use Data::Dumper;

set show_errors => 1;
set warnings => 1;
set log => 'debug';
set environment => 'development';

before sub {
	open my $fh, ">>/tmp/caca_before";
	print $fh Dumper(request);
	close $fh;
};
after sub {
	open my $fh, ">>/tmp/caca_after";
	print $fh Dumper(response);
	close $fh;
};
get '/', sub { "Bazinga" . "\n" };

dance;
