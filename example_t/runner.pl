use strict;
use warnings;
use Procrustes::TestSuite;

# list of test modules - a dynamic plugin loader should be coming later
use PassThis;
use AnotherTest;
use AdvancedExample;

# instantiate the test suite
my $test_suite = Procrustes::TestSuite->new();

# load plugins here
$test_suite->add_plugin(   PassThis->new()            );
$test_suite->add_plugin(   AnotherTest->new()         );
$test_suite->add_plugin(   AdvancedExample->new()     );

# run tests now
$test_suite->go();
my $failure_count = $test_suite->report();

exit($failure_count);
