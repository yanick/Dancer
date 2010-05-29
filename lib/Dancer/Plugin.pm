package Dancer::Plugin;
use strict;
use warnings;

use Dancer::Config 'setting';

use base 'Exporter';
use vars qw(@EXPORT);

@EXPORT = qw(
    register
    register_plugin
    plugin_setting
    add_hook
    run_hook
);

my @_reserved_keywords = @Dancer::EXPORT;

my $_keywords = [];

my $_hooks = {};

sub add_hook {
    my ($hook_position, $code) = @_;
    if (ref $code ne 'CODE') {
        die "this is not a code ref";
    }
    push @{$_hooks->{$hook_position}}, $code;
}

sub run_hook {
    my $class         = shift;
    my $hook_position = shift;
    foreach my $h ( @{ $_hooks->{$hook_position} } ) {
        $h->(@_);
    }
}

sub plugin_setting {
    my $plugin_orig_name = caller();
    my ($plugin_name) = $plugin_orig_name =~ s/Dancer::Plugin:://;

    my $settings = setting('plugins');

    foreach (   $plugin_name,    $plugin_orig_name,
             lc $plugin_name, lc $plugin_orig_name) 
    {
        return $settings->{$_}
            if ( exists $settings->{$_} );
    }
    return undef;
}


sub register($$) {
    my ($keyword, $code) = @_;
    if (ref $code ne 'CODE') {
        die "this is not a coderef";
    }
    if (grep {$_ eq $keyword} @_reserved_keywords) {
        die "You can't use $keyword, this is a reserved keyword";
    }
    push @$_keywords, [$keyword => $code];
}

sub register_plugin {
    my ($plugin) = caller();
    my ($application) = caller(1);

    for my $keyword (@$_keywords) {
        my ($name, $code) = @$keyword;
        {
            no strict 'refs';
            *{"${application}::${name}"} = $code;
        }
    }
}

1;
__END__

=pod

=head1 NAME

Dancer::Plugin

=head1 DESCRIPTION

Create plugins for Dancer

=head1 SYNOPSIS

  package Dancer::Plugin::LinkBlocker;
  use Dancer ':syntax';
  use Dancer::Plugin;

  register block_links_from => sub {
    my $conf = plugin_setting();
    my $re = join ('|', @{$conf->{hosts}});
    before sub {
        if (request->referer && request->referer =~ /$re/) {
            status 403 || $conf->{http_code};
        }
    };
  };

  register_plugin;
  1;

=head1 PLUGINS

You can extend Dancer by writing your own Plugin.

=head2 METHODS

=over 4

=item B<add_hook>

The following event are supported :

=over 4

=item before_dispatch

=item before_template

=item after_dispatch

=back

=item B<register>

=item B<register_plugin>

=item B<plugin_setting>

Configuration for plugin should be structured like this in the config.yaml of the application:

  plugins:
    plugin_name:
      key: value

If plugin_setting is called inside a plugin, the appropriate configuration will be returned. The plugin_name should be the name of the package, or, if the plugin name is under the Dancer::Plugin:: namespace, the end part of the plugin name.

=back
