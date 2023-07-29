#!/usr/bin/perl
package UpstreamQueryTests;
use strict;
use warnings;
use Moose;
extends 'Test::Module::Runnable';

use Cache::MemoryCache;
use English qw(-no_match_vars);
use Geo::Weather::VisualCrossing::Private::UpstreamQuery;
use POSIX;
use Test::Deep qw(cmp_deeply all isa methods bool re);
use Test::Exception;
use Test::More;

# nb. this is not a leaked real password; it is not a valid key, just a placeholder during development
has __apiKey => (is => 'rw', isa => 'Str', default => 'WmzvSd9xay0jFjf7');

sub setUp {
	my ($self) = @_;

	$self->sut(Geo::Weather::VisualCrossing::Private::UpstreamQuery->new(apiKey => $self->__apiKey));

	return EXIT_SUCCESS;
}

sub testSomething {
	my ($self) = @_;
	plan tests => 1;

	my $uri = $self->sut->__makeURI('Ebbw Vale');
	is($uri, 'https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/Ebbw%20Vale/today?unitGroup=us&key=WmzvSd9xay0jFjf7&contentType=json',
	    $uri);

	return EXIT_SUCCESS;
}

package main;
use strict;
use warnings;
exit(UpstreamQueryTests->new->run);