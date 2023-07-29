package Daybo::API::Server::Modules::Weather::UpstreamQuery;
use Moose;

use LWP::UserAgent;
use URI::Escape;

has __ua => (is => 'rw', isa => 'LWP::UserAgent', default => \&__makeUserAgent, lazy => 1);

sub __makeUserAgent {
	my ($self) = @_;

	my $ua = LWP::UserAgent->new;
	$ua->timeout(120);
	$ua->env_proxy;

	return $ua;
}

sub query {
	my ($self, $location) = @_;

	my $uri = __makeURI($location);
	my $response = $self->__ua->get($uri);
	if ($response->is_success) {
		return $response->content;
	}

	return '';
}

sub __makeURI {
	my ($location) = @_;

	$location = uri_escape($location);
	my $uri = 'https://api.scorpstuff.com/weather.php?units=imperial&city=';
	$uri .= $location if ($location);

	return $uri;
}

1;
