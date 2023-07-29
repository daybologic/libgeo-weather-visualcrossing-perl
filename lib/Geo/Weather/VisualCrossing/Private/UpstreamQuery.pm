package Geo::Weather::VisualCrossing::Private::UpstreamQuery;
use Moose;

use LWP::UserAgent;
use URI::Escape;

has apiKey => (isa => 'Str', is => 'ro', required => 1);
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
	my ($self, $location) = @_;

	my $uri = URI->new();

	$uri->scheme('https');
	$uri->host('weather.visualcrossing.com');
	$uri->path(sprintf(
		'VisualCrossingWebServices/rest/services/timeline/%s/today',
		uri_escape($location),
	));

	$uri->query(sprintf(
		'unitGroup=us&key=%s&contentType=json',
		$self->apiKey,
	));

	return $uri->as_string();
}

1;
