package Geo::Weather::VisualCrossing;
use Moose;

use Data::Dumper;
use JSON;
use LWP::UserAgent;
use URI;

BEGIN {
	our $VERSION = '1.1.1';
}

has __apiKey => (isa => 'Str', is => 'ro', init_arg => undef, lazy => 1, required => 1, default => \&__makeApiKey);

has __ua => (isa => 'LWP::UserAgent', is => 'ro', init_arg => undef, lazy => 1, required => 1, default => \&__makeUA);

has __decoder => (isa => 'JSON', is => 'ro', init_arg => undef, lazy => 1, required => 1, default => \&__makeDecoder);

sub lookup {
	my ($self, $location) = @_;

	my $response = $self->__ua->get($self->__makeURI($location));
	if (!$response->is_success) {
		return;
	}

	my $result = $self->__decoder->decode($response->decoded_content);
	warn Dumper $result;

	return $result; # TODO: Return a well-defined class
}

sub __makeApiKey {
	my ($self) = @_;
	#return $self->_config->get($self, 'api_key'); # FIXME
	return 'Oa1dCEUAqVgZbCrg'; # nb. this is not a leaked real password; it is not a valid key, just a placeholder during development
}

# TODO: You must introduce a base class which creates one UA with one UA String!
sub __makeUserAgent {
	my ($self) = @_;

	my $ua = LWP::UserAgent->new();

	$ua->agent(join('/', 'telegram-bot/m6kvmdlcmdr', '1.1.1'));
	#$ua->default_header(apikey => $self->__apiKey); # In this API, it's in the GET request
	$ua->timeout(120);

	return $ua;
}

sub __makeDecoder {
	return JSON->new();
}

1;
