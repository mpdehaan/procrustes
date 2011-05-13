
use MooseX::Declare;

class Procrustes::TestResults {

    use Method::Signatures::Simple name => 'action';

    has failures   => (isa => 'ArrayRef[Procrustes::TestCaseFailure]', is => 'rw', required => 0, default => sub { return []; });
    # TODO: consider making a TestCaseSuccess extending from TestCaseResult so that we can include benchmark times
    # with every single test automatically
    has successes  => (isa => 'ArrayRef[Procrustes::TestCase]',        is => 'rw', required => 0, default => sub { return []; });

    action add_failure($failure) {
        # FIXME: use the Moose array push traits thingy
        my $fails = $self->failures();
        push @$fails, $failure;
        print "FAILED: " . $failure->case->case_name() . "\n";
        $self->failures($fails);
        return $failure;
    }

    action add_success($case) {
        # FIXME: use the Moose array push traits thingy
        my $works = $self->successes();
        push @$works, $case;
        $self->successes($works);
        return $case;
    }

    action failure_count() {
        return scalar @{$self->failures()};
    }

    action success_count() {
        return scalar @{$self->successes()};
    }

    # TODO: to_s()
    # TODO: success_count
    # TODO: failure_count 
}
