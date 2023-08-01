#!/usr/bin/perl

package main;

use ExtUtils::MakeMaker;
use strict;
use warnings;

WriteMakefile(
	NAME         => 'Geo::Weather::VisualCrossing',
	VERSION_FROM => 'lib/Geo/Weather/VisualCrossing.pm', # finds $VERSION
	AUTHOR       => 'Duncan Ross Palmer, 2E0EOL (palmer@overchat.org)',
	ABSTRACT     => 'Geo::Weather::VisualCrossing Perl interface (www.visualcrossing.com)',

	PREREQ_PM => {
		'Moose'                  => 0,
		'Test::MockModule'       => 0,
		'Test::More'             => 0,
	}, BUILD_REQUIRES => {
		'Moose'                  => 0,
		'Readonly'               => 0,
		'Test::Deep'             => 0,
		'Test::Exception'        => 0,
		'Test::Module::Runnable' => 0,
		'Test::More'             => 0,
	},
);
