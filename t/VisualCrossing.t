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

	#my $response = $self->sut->lookup('Ebbw Vale');
	my $response = $self->sut->lookup('Houston,Texas');
	diag(explain($response));

	return EXIT_SUCCESS;
}

package main;
use strict;
use warnings;
exit(VisualCrossingTests->new->run);
