
use MooseX::Declare;

class Procrustes::TestCase {

    use Method::Signatures::Simple name => 'action';
    use Procrustes::TestCaseFailure;
    use Devel::StackTrace;
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
            my $trace = Devel::StackTrace->new();
            
            # TODO: when we have a traceback, log a *short* traceback using Devel::StackTrace
            my $error = $@;
            my $end = DateTime->now();
            $hooks_instance->teardown();
            $self->duration($end->epoch() - $start->epoch());
            my $failure = Procrustes::TestCaseFailure->new(case => $self, error => $self->generate_trace_text($error, $trace));
            return $test_results->add_failure($failure);
        };

        
    };

    # format the traceback data such that it can be logged nicely
    # runs from top (most recent) of stack to bottom.
    action generate_trace_text($error, $trace) {
        my $buf = "";
        my $count = 0;
        $buf .= "          error: $error";
        while (my $frame = $trace->next_frame) {
            $buf .= "          " . $frame->package . " " . $frame->filename . " " . $frame->line . "\n";
            last if ++$count > 10;
        }
        return $buf;
    }


}
