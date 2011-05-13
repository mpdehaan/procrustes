
use MooseX::Declare;

class Procrustes::TestCase {

    use Method::Signatures::Simple name => 'action';
    use Procrustes::TestCaseFailure;
    use Try::Tiny;

    has case_name  => (isa => 'Str',      is => 'rw', required => 1);
    has test_block => (isa => 'CodeRef',  is => 'rw', required => 1);

    action run($test_results) {

        try {
            my $result = $self->test_block()->();
            unless ($result) {
                my $failure = Procrustes::TestCaseFailure->new(case => $self, result => $result);
                return $test_results->add_failure($failure);
            }
        } catch {
            # TODO: when we have a traceback, log a *short* traceback using Devel::StackTrace
            my $err = $_;
            my $failure = Procrustes::TestCaseFailure->new(case => $self, error => $_);
            return $test_results->add_failure($failure);
        };

        # TODO: consider making a TestCaseSuccess object w/ a common TestCaseResult base class
        return $test_results->add_success($self);
        
    };

}
