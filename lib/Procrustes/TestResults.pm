
use MooseX::Declare;

class Procrustes::TestResults {

    use Method::Signatures::Simple name => 'action';

    has failures   => (isa => 'ArrayRef[Procrustes::TestCaseFailure]', is => 'rw', required => 0, default => sub { return []; });
    # TODO: consider making a TestCaseSuccess extending from TestCaseResult so that we can include benchmark times
    # with every single test automatically
    has successes  => (isa => 'ArrayRef[Procrustes::TestCase]',        is => 'rw', required => 0, default => sub { return []; });
    has plan_name  => (isa => 'Str', is => 'rw', required => 1);
 

    action add_failure($failure) {
        # FIXME: use the Moose array push traits thingy
        my $fails = $self->failures();
        push @$fails, $failure;
        if (defined $failure->error()) {
            print $failure->error(); # trimmed stack trace
        }
        print "       FAILED\n";
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

    action duration() {
        my $total = 0;
        foreach my $result (@{$self->failures()}) { $total += $result->case->duration() };
        foreach my $result (@{$self->successes()}) { $total += $result->duration() };
        return $total;
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
    
    action failed_percent() {
        return 0 unless $self->total_count();
        return sprintf "%.2f", ($self->failure_count() / $self->total_count()) * 100;
    }

    action report() {
        print "\n";
        print "    Success Summary\n";
        print "    ---------------\n";
        foreach my $success (@{$self->successes()}) {
            printf "    %8f s | %s\n", ($success->duration(), $success->case_name()); 
        }
        print "\n";
        print "    Failure Summary\n";
        print "    ---------------\n";
        foreach my $failure (@{$self->failures()}) {
            printf "    %8f s |  %s\n", ($failure->case->duration(), $failure->case->case_name());
        }
        print "\n";
        
        if ($self->failure_count()) {
            print "    FAILED: (" . $self->failure_count() . "/" . $self->total_count() . ") " . $self->failed_percent() . "% \n";
        } else {
            print "    success: all " . $self->total_count() . " tests passed\n";
        }
    }
}
