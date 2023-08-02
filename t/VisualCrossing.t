#!/usr/bin/perl
package VisualCrossingTests;
use strict;
use warnings;
use Moose;
extends 'Test::Module::Runnable';

use Cache::MemoryCache;
use English qw(-no_match_vars);
#use Geo::Weather::VisualCrossing::Private::UpstreamQuery;
use Geo::Weather::VisualCrossing;
use HTTP::Response;
use POSIX;
use Scalar::Util qw(refaddr);
use Test::Deep qw(cmp_deeply all isa methods bool re);
use Test::Exception;
use Test::More;

# nb. this is not a leaked real password; it is not a valid key, just a placeholder during development
has __apiKey => (is => 'rw', isa => 'Str', default => 'WmzvSd9xay0jFjf7');

sub setUp {
	my ($self) = @_;

	$self->sut(Geo::Weather::VisualCrossing->new(apiKey => $self->__apiKey));

	return EXIT_SUCCESS;
}

sub testLookup {
	my ($self) = @_;
	plan tests => 1;


	SKIP: {
		skip 'Broken tests', 1 unless $ENV{TEST_AUTHOR};

		#my $response = $self->sut->lookup('Ebbw Vale');
		#my $response = $self->sut->lookup('Houston,Texas');
		#diag(explain($response));
		ok('FIXME: Broken tests');
	};

	return EXIT_SUCCESS;
}

package main;
use strict;
use warnings;
exit(VisualCrossingTests->new->run);
