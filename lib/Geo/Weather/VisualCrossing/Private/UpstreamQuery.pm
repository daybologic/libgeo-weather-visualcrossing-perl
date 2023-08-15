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

package Geo::Weather::VisualCrossing::Private::UpstreamQuery;
use Moose;

use English;
use Geo::Weather::VisualCrossing;
use JSON;
use LWP::UserAgent;
use URI::Escape;

has apiKey => (isa => 'Str', is => 'ro', required => 1);
has host => (isa => 'Str', is => 'rw', default => 'weather.visualcrossing.com');
has __ua => (is => 'rw', isa => 'LWP::UserAgent', default => \&__makeUserAgent, lazy => 1);
has __decoder => (is => 'ro', isa => 'JSON', lazy => 1, default => \&__makeDecoder);

sub query {
	my ($self, $location) = @_;

	my $uri = $self->__makeURI($location);
	my $response = $self->__ua->get($uri);
	if ($response->is_success) {
		my $decoded = '';
		eval {
			$decoded = $self->__decoder->decode($response->content);
		};
		if (my $evalError = $EVAL_ERROR) {
			warn $evalError;
		}
		# TODO: Better handling for eval fail f7be3d6e-2dfd-11ee-afc1-839313550c4c

		return $decoded;
	} else {
		warn $response->status_line;
		warn $uri;
	}

	return ''; # TODO: Better handling for non-success (need a logger?) 3e4fb046-2dfe-11ee-afc2-9f47472335e0
}

sub __makeURI {
	my ($self, $location) = @_;

	my $uri = URI->new();

	$uri->scheme('https');
	$uri->host($self->host);
	$uri->path(sprintf(
		'VisualCrossingWebServices/rest/services/timeline/%s/today',
		uri_escape_utf8($location),
	));

	$uri->query(sprintf(
		'unitGroup=us&key=%s&contentType=json',
		$self->apiKey,
	));

	return $uri->as_string();
}

sub __makeUserAgent {
	my ($self) = @_;

	my $ua = LWP::UserAgent->new();

	$ua->agent(join('/', 'Geo::Weather::VisualCrossing', $Geo::Weather::VisualCrossing::VERSION));
	$ua->timeout(120);
	$ua->env_proxy;

	return $ua;
}

sub __makeDecoder {
	return JSON->new->allow_nonref;
}

1;
