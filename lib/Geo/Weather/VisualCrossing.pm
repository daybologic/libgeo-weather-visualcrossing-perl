package Geo::Weather::VisualCrossing;
use Moose;

use Data::Dumper;
use JSON;
use LWP::UserAgent;
use URI;

BEGIN {
	our $VERSION = '0.1.0';
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

sub __makeDecoder {
	return JSON->new();
}

1;
