# Geo::Weather::VisualCrossing for Perl
# Copyright (c) 2023, Duncan Ross Palmer (2E0EOL) and others,
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
#
#  1. Redistributions of source code must retain the above copyright
#     notice, this list of conditions and the following disclaimer.
#
#  2. Redistributions in binary form must reproduce the above copyright
#     notice, this list of conditions and the following disclaimer in the
#     documentation and/or other materials provided with the distribution.
#
#  3. Neither the name of the project nor the names of its contributors
#     may be used to endorse or promote products derived from this software
#     without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE PROJECT AND CONTRIBUTORS ``AS IS'' AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED.  IN NO EVENT SHALL THE PROJECT OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
# OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
# HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
# LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
# OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
# SUCH DAMAGE.

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
