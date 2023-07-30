package Geo::Weather::VisualCrossing::Report::Temperature;
use Moose;

has degF => (is => 'ro', isa => 'Num');
has degC => (is => 'ro', isa => 'Num', lazy => 1, default => \&__makeDegC);
has degK => (is => 'ro', isa => 'Num'); # TODO

sub __makeDegC {
	my ($self) = @_;
	# °C = (°F - 32) x 5/9
	return ($self->degF - 32) * 5/9;
}

1;
