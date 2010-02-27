#Courtesy of chromatic
#http://search.cpan.org/~chromatic/Test-Kwalitee/lib/Test/Kwalitee.pm

# $Id$

use strict;
use warnings;
use Env qw($TEST_AUTHOR);
use Test::More;

if (not $TEST_AUTHOR) {
    plan skip_all => 'set TEST_AUTHOR to enable this test';
}

eval {
    require Test::Kwalitee;
    Test::Kwalitee->import();
};

if ($@) {
    plan skip_all => 'Test::Kwalitee not installed; skipping';
}
