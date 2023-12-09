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

package UpstreamQueryTests;
use lib 'externals/libtest-module-runnable-perl/lib';
use strict;
use warnings;
use Moose;
extends 'Test::Module::Runnable';

use Cache::MemoryCache;
use English qw(-no_match_vars);
use Geo::Weather::VisualCrossing::Private::UpstreamQuery;
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

	$self->sut(Geo::Weather::VisualCrossing::Private::UpstreamQuery->new(apiKey => $self->__apiKey));

	return EXIT_SUCCESS;
}

sub testURI {
	my ($self) = @_;
	plan tests => 1;

	my $uri = $self->sut->__makeURI('Ebbw Vale');
	is($uri, 'https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/Ebbw%20Vale/today?unitGroup=us&key=WmzvSd9xay0jFjf7&contentType=json',
	   'uri');

	return EXIT_SUCCESS;
}

sub testUA {
	my ($self) = @_;
	plan tests => 3;

	$self->mock('LWP::UserAgent', 'env_proxy');

	my $agentString = 'Geo::Weather::VisualCrossing/0.1.3';
	my $ua = $self->sut->__ua;

	is(refaddr($self->sut->__ua), refaddr($ua), 'persistent object');
	cmp_deeply($ua, all(
		methods(
			agent   => $agentString,
			timeout => 120,
		),
	), 'deep UA inspection');

	my $mockCalls = $self->mockCalls('LWP::UserAgent', 'env_proxy');
	cmp_deeply($mockCalls, [[]], 'env_proxy used') or diag(explain($mockCalls));

	return EXIT_SUCCESS;
}

sub testQuerySuccess {
	my ($self) = @_;
	plan tests => 2;

	$self->sut->host('api-success.demo-weather.test');
	my $json = $self->__makeJson();
	$self->mock(ref($self->sut->__ua), 'get', [
		HTTP::Response->new(200, 'Mock success', undef, $json),
	]);

	my $response = $self->sut->query('Bath, GB');
	is($response->{id}, '64c4eacbba1d9daf46285035', 'id in JSON');
	is($response->{children}->[2]->{name}, 'Jesse Austin', 'child name at index 2 in JSON');

	return EXIT_SUCCESS;
}

sub testQueryBadData {
	my ($self) = @_;
	plan tests => 1;

	$self->sut->host('f7be3d6e-2dfd-11ee-afc1-839313550c4c.demo-weather.test');
	my $json = 'nPXnOEkIr7Qxmspc'; # obviously not valid JSON
	$self->mock(ref($self->sut->__ua), 'get', [
		HTTP::Response->new(200, 'Mock success', undef, $json),
	]);

	my $response = $self->sut->query('Bath, GB');
	is($response, '', 'empty response') or diag(explain($response));

	return EXIT_SUCCESS;
}

sub testQueryErrorResponse {
	my ($self) = @_;
	plan tests => 1;

	$self->sut->host('3e4fb046-2dfe-11ee-afc2-9f47472335e0.demo-weather.test');
	my $json = $self->__makeJson();
	$self->mock(ref($self->sut->__ua), 'get', [
		HTTP::Response->new(401, 'oof', undef, $json),
	]);

	my $response = $self->sut->query('Bath, GB');
	is($response, '', 'empty response') or diag(explain($response));

	return EXIT_SUCCESS;
}

sub __makeJson {
	my ($self) = @_;

	return '{
		"id": "64c4eacbba1d9daf46285035",
		"children": [
			{
				"name": "Kaylor William",
				"age": 6
			},
			{
				"name": "Vasquez Robbins",
				"age": 10
			},
			{
				"name": "Jesse Austin",
				"age": 4
			},
			{
				"name": "Jude Battle",
				"age": 1
			},
			{
				"name": "Leslie Ellison",
				"age": 3
			}
		],
		"currentJob": {
			"title": "Developer",
			"salary": "mask;"
		},
		"jobs": [
			{
				"title": "teacher",
				"salary": "R$ 6.343,76"
			},
			{
				"title": "CEO",
				"salary": "R$ 4.709,27"
			}
		],
		"maxRunDistance": 13,
		"cpf": "031.622.678-54",
		"cnpj": "22.023.546/0001-09",
		"pretendSalary": "R$ 7.489,88",
		"age": 66,
		"gender": "male",
		"firstName": "Rojas",
		"lastName": "Lott",
		"phone": "+55 (83) 92189-3208",
		"address": "581 Kent Avenue - Shindler, New Hampshire, Bhutan.",
		"hairColor": "red"
	}';
}

package main;
use strict;
use warnings;
exit(UpstreamQueryTests->new->run);
