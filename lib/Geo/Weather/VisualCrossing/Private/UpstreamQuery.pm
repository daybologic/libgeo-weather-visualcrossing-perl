package Geo::Weather::VisualCrossing::Private::UpstreamQuery;
use Moose;

use English;
use Geo::Weather::VisualCrossing;
use JSON;
use LWP::UserAgent;
use URI::Escape;

has apiKey => (isa => 'Str', is => 'ro', required => 1);
has host => (isa => 'Str', is => 'rw', default => 'weather.visualcrossing.com');
has __ua => (is => 'rw', isa => 'LWP::UserAgent', default => \&__makeUserAgent, lazy => 1);
has __decoder => (is => 'ro', isa => 'JSON', lazy => 1, default => \&__makeDecoder);

sub query {
	my ($self, $location) = @_;

	my $uri = $self->__makeURI($location);
	my $response = $self->__ua->get($uri);
	if ($response->is_success) {
		my $decoded = '';
		eval {
			$decoded = $self->__decoder->decode($response->content);
		};
		if (my $evalError = $EVAL_ERROR) {
			warn $evalError;
		}
		# TODO: Better handling for eval fail f7be3d6e-2dfd-11ee-afc1-839313550c4c

		return $decoded;
	} else {
		warn $response->status_line;
		warn $uri;
	}

	return ''; # TODO: Better handling for non-success (need a logger?) 3e4fb046-2dfe-11ee-afc2-9f47472335e0
}

sub __makeURI {
	my ($self, $location) = @_;

	my $uri = URI->new();

	$uri->scheme('https');
	$uri->host($self->host);
	$uri->path(sprintf(
		'VisualCrossingWebServices/rest/services/timeline/%s/today',
		uri_escape_utf8($location),
	));

	$uri->query(sprintf(
		'unitGroup=us&key=%s&contentType=json',
		$self->apiKey,
	));

	return $uri->as_string();
}

sub __makeUserAgent {
	my ($self) = @_;

	my $ua = LWP::UserAgent->new();

	$ua->agent(join('/', 'Geo::Weather::VisualCrossing', $Geo::Weather::VisualCrossing::VERSION));
	$ua->timeout(120);
	$ua->env_proxy;

	return $ua;
}

sub __makeDecoder {
	return JSON->new->allow_nonref;
}

1;
