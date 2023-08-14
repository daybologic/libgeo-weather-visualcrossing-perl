package Geo::Weather::VisualCrossing;
use Moose;

use Geo::Weather::VisualCrossing::Private::UpstreamQuery;
use Geo::Weather::VisualCrossing::Report;
use Geo::Weather::VisualCrossing::Report::Temperature;
use Geo::Weather::VisualCrossing::Report::WindSpeed;

BEGIN {
	our $VERSION = '0.1.2';
}

has apiKey => (isa => 'Str', is => 'ro', lazy => 1, default => \&__makeApiKey);
has __upstreamQuery => (isa => 'Geo::Weather::VisualCrossing::Private::UpstreamQuery', is => 'rw', lazy => 1, default => \&__makeUpstreamQuery);

sub lookup {
	my ($self, $location) = @_;

	my $response = $self->__upstreamQuery->query($location);
	if (length($response) > 0) {
		return Geo::Weather::VisualCrossing::Report->new(
			description    => join(', ', $response->{currentConditions}->{conditions}, $response->{description}),
			humidity       => $response->{currentConditions}->{humidity},
			plocation      => $response->{resolvedAddress},
			sunset         => $response->{currentConditions}->{sunset},
			temperature    => Geo::Weather::VisualCrossing::Report::Temperature->new(
				degF   => $response->{currentConditions}->{temp},
			),
			wind           => Geo::Weather::VisualCrossing::Report::WindSpeed->new(
				deg360 => $response->{currentConditions}->{winddir}, # I think this is degrees up to 360
				speed  => $response->{currentConditions}->{windspeed},
			),
		);
	}

	return $response; # TODO: Return a well-defined class
}

sub __makeUpstreamQuery {
	my ($self) = @_;
	return Geo::Weather::VisualCrossing::Private::UpstreamQuery->new(apiKey => $self->apiKey);
}

sub __makeApiKey {
	my ($self) = @_;
	#return $self->_config->get($self, 'api_key'); # FIXME
	return 'Oa1dCEUAqVgZbCrg'; # nb. this is not a leaked real password; it is not a valid key, just a placeholder during development
}

1;
