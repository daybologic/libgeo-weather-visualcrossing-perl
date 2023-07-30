package Geo::Weather::VisualCrossing::Report;
use Moose;

has description => (is => 'ro', isa => 'Str', required => 1);
has humidity => (is => 'ro', isa => 'Num', required => 1);
has plocation => (is => 'ro', isa => 'Str', required => 1);
has sunset => (is => 'ro', isa => 'Str', required => 1); # this is a time HH:mm:ss
has temperature => (is => 'ro', isa => 'Geo::Weather::VisualCrossing::Report::Temperature', required => 1);
has wind => (is => 'ro', isa => 'Geo::Weather::VisualCrossing::Report::WindSpeed', required => 1);

sub getScorpStuffFormat {
	my ($self) = @_;

	return sprintf("Weather for %s: Scattered clouds with a temperature of %.1f F\n\n" .
	    "(%d C). Wind is blowing from the %s at %.2f mph (%.2f kph)\n\n" .
	    "and the humidity is %d%%\n",
		$self->plocation,
		$self->temperature->degF,
		$self->temperature->degC,
		$self->wind->direction,
		$self->wind->speed,
		$self->wind->to_kph(),
		$self->humidity,
	);
}

1;
