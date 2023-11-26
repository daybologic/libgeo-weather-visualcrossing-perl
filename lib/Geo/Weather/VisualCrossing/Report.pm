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

	return sprintf("Weather for %s: %s with a temperature of %.1f F\n\n" .
	    "(%.1f C). Wind is blowing from the %s at %.2f mph (%.2f kph)\n\n" .
	    "and the humidity is %d%%\n",
		$self->plocation,
		$self->description,
		$self->temperature->degF,
		$self->temperature->degC,
		$self->wind->direction,
		$self->wind->speed,
		$self->wind->to_kph(),
		$self->humidity,
	);
}

1;
