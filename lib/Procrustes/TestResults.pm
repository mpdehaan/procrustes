
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
        print "**** failed:  " . $failure->case->case_name() . "\n";
        $self->failures($fails);
        return $failure;
    }

    action add_success($case) {
        # FIXME: use the Moose array push traits thingy
        print "**** success: " . $case->case_name() . "\n";
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
  
    action total_count() {
        return $self->failure_count() + $self->success_count();
    }

    action passed_percent() {
        return 0 unless $self->total_count();
        return sprintf "%.2f", ($self->success_count() / $self->total_count()) * 100;
    }

    action report() {
        print "\n";
        print "Success Summary\n";
        print "---------------\n";
        foreach my $success (@{$self->successes()}) {
            printf "%8f s | %s\n", ($success->duration(), $success->case_name()); 
        }
        print "\n";
        print "Failure Summary\n";
        print "---------------\n";
        foreach my $failure (@{$self->failures()}) {
            printf "%8f s |  %s\n", ($failure->case->duration(), $failure->case->case_name());
        }
        print "\n";
        print "passed: (" . $self->success_count() . "/" . $self->total_count() . ") " . $self->passed_percent() . "% \n";
    }

}
