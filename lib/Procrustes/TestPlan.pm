
use MooseX::Declare;

# TODO: This is really a TestSuite class

class Procrustes::TestPlan {

    use Method::Signatures::Simple name => 'action';
    use Procrustes::TestCase;
    use Procrustes::TestResults;

    # data attributes
    has plan_name   => (isa => 'Str', is => 'rw', required => 0, init_arg => undef,);
    has test_cases  => (isa => 'ArrayRef[Procrustes::TestCase]', is => 'rw', init_arg => undef, default => sub { 
         return [] }
    );

    # produce a single test case, analogous to a RSpec "describe do", more or less
    action _create_single_test($case_name, $test_block) {
         # TODO: use the Moose array push attribute trait thingy 
         my $cases = $self->test_cases();
         my $new_case = Procrustes::TestCase->new(
             case_name  => $case_name,
             test_block => $test_block 
         );
         push @$cases, $new_case;
         $self->test_cases($cases);
    }

    # run a whole set of tests
    action describe($plan_name, $tests) {
         $self->plan_name($plan_name);
         while(1) {
               my $case_name  = shift(@$tests);
               last unless $case_name;
               my $test_block = shift(@$tests);
               die "missing block" unless $test_block;
               $self->_create_single_test($case_name, $test_block);
         }
         return $self;
    }
    
    action go() {
         my $test_results = Procrustes::TestResults->new();
         # TODO: create some sort of test result object that each test case adds to...
         foreach my $test (@{$self->test_cases()}) {
               print "**** running: " . $test->case_name() . "\n";      
               $test->run($test_results);
         }
         return $test_results;
    }

}
