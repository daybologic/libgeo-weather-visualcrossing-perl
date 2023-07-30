package Geo::Weather::VisualCrossing::Report::WindSpeed;
use Moose;

use Readonly;

has deg360 => (is => 'ro', isa => 'Num');
has speed => (is => 'ro', isa => 'Num', required => 1);

sub direction {
	my ($self) = @_;

	Readonly my @DIRECTION_NAMES => (
		'North',
		'North-East',
		'East',
		'South-East',
		'South',
		'South-West',
		'West',
		'North-West',
	);

	my @closestToZero = ( );
	for (my $i = 0; $i < scalar(@DIRECTION_NAMES); $i++) {
		$closestToZero[$i] = $self->deg360 - ($i * 45);
	}

	return $DIRECTION_NAMES[ __closestToZero(\@closestToZero) ];
}

sub to_kph {
	my ($self) = @_;
	return $self->speed * 1.609;
}

sub __closestToZero {
	my ($numbers) = @_;

	my $closest = 0;
	my $idx = -1;

	return $idx if (scalar(@$numbers) == 0);

	for (my $i = 0; $i < scalar(@$numbers); $i++) {
		if ($closest == 0) {
			$closest = $numbers->[$i];
			$idx = $i;
		} elsif ($numbers->[$i] > 0 && $numbers->[$i] <= abs($closest)) {
			$closest = $numbers->[$i];
			$idx = $i;
		} elsif ($numbers->[$i] < 0 && - $numbers->[$i] < abs($closest)) {
			$closest = $numbers->[$i];
			$idx = $i;
		}
	}

	return $idx;
}

1;
