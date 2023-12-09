#!/usr/bin/perl

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

package ReportTests;
use lib 'externals/libtest-module-runnable-perl/lib';
use strict;
use warnings;
use Moose;
extends 'Test::Module::Runnable';

use Cache::MemoryCache;
use English qw(-no_match_vars);
use Geo::Weather::VisualCrossing::Report;
use Geo::Weather::VisualCrossing::Report::Temperature;
use Geo::Weather::VisualCrossing::Report::WindSpeed;
use POSIX;
use Test::Deep qw(cmp_deeply all isa methods bool re);
use Test::Exception;
use Test::More;

sub setUp {
	my ($self) = @_;

	$self->sut(Geo::Weather::VisualCrossing::Report->new(
		description    => 'Scattered clouds',
		humidity       => 58,
		plocation      => 'Leeds, GB',
		sunset         => '20:59:01',
		temperature    => Geo::Weather::VisualCrossing::Report::Temperature->new(
			degF   => 77.10,
		),
		wind           => Geo::Weather::VisualCrossing::Report::WindSpeed->new(
			deg360 => 212,
			speed  => 17.27,
		),
	));

	return EXIT_SUCCESS;
}

sub testScorpStuffFormat {
	my ($self) = @_;
	plan tests => 1;

	my $expected = "Weather for Leeds, GB: Scattered clouds with a temperature of 77.1 F\n\n" .
	    "(25.1 C). Wind is blowing from the South-West at 17.27 mph (27.79 kph)\n\n" .
	    "and the humidity is 58%\n";

	my $output = $self->sut->getScorpStuffFormat();
	is($output, $expected, 'Output similar to https://api.scorpstuff.com/weather.php');

	return EXIT_SUCCESS;
}

package main;
use strict;
use warnings;
exit(ReportTests->new->run);
