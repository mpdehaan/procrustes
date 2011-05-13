
use MooseX::Declare;

class Procrustes::TestCase {

    use Method::Signatures::Simple name => 'action';
    use Procrustes::TestCaseFailure;


    use DateTime;

    has case_name  => (isa => 'Str',      is => 'rw', required => 1);
    has test_block => (isa => 'CodeRef',  is => 'rw', required => 1);
    has duration   => (isa => 'Int',      is => 'rw', required => 0,  default => 0, init_arg => undef);

    action run($test_results, $hooks_instance) {

        $hooks_instance->setup(); # consider running in eval
        my $start = DateTime->now();

        eval {
            my $result = $self->test_block()->();
            my $end = DateTime->now();
            $hooks_instance->teardown();
            $self->duration($end->epoch() - $start->epoch());
            unless ($result) {
                my $failure = Procrustes::TestCaseFailure->new(case => $self, result => $result);
                return $test_results->add_failure($failure);
            } else {
                return $test_results->add_success($self);
            }
        } or do {
            # TODO: when we have a traceback, log a *short* traceback using Devel::StackTrace
            my $error = $@;
            my $end = DateTime->now();
            $hooks_instance->teardown();
            $self->duration($end->epoch() - $start->epoch());
            my $err = $_;
            my $failure = Procrustes::TestCaseFailure->new(case => $self, error => $error);
            return $test_results->add_failure($failure);
        };

        
    };

}
