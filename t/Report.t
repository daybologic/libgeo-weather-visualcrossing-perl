#!/usr/bin/perl
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
	    "(25 C). Wind is blowing from the South-West at 17.27 mph (27.79 kph)\n\n" .
	    "and the humidity is 58%\n";

	my $output = $self->sut->getScorpStuffFormat();
	is($output, $expected, 'Output similar to https://api.scorpstuff.com/weather.php');

	return EXIT_SUCCESS;
}

package main;
use strict;
use warnings;
exit(ReportTests->new->run);
