
use MooseX::Declare;

class Procrustes::TestSuite {
 
    use Method::Signatures::Simple name => 'action';
    use Procrustes::TestPlan;
   
    has test_plans   => (isa => 'ArrayRef[Procrustes::TestPlan]', is => 'rw'); 
    has test_results => (isa => 'ArrayRef[Procrustes::TestResults]', is => 'rw'); 

    action add_plugin($plugin) {
        # currently each plugin can only have one plan, which isn't so interesting.
        my $plan = $plugin->plan();
        $plan->hooks_instance($plugin); # where are setup/teardown defined?
        my $plans = $self->test_plans();
        push @{$plans}, $plan;
        $self->test_plans($plans);
        return $self;
    }

    # run the plans
    action go() {

        foreach my $plan (@{$self->test_plans()}) {
            my $test_result = $plan->go();
            my $test_results = $self->test_results();
            push @{$test_results}, $test_result;
            $self->test_results($test_results);
            $test_result->report(); 
        }
        return $self;
    }

    # compute aggregrate results
    action report() {

        print "\n";
        print "Summary\n";
        print "=======\n";
        print "\n";

        my ($total_duration, $total_success, $total_failed, $total_attempted) = (0,0,0,0);
        printf "    %10s s | %-50s | %10s | %10s | %10s\n", "time", "suite", "passed", "failed", "%failed";
        foreach my $result (@{$self->test_results()}) {
            $total_duration  += $result->duration();
            $total_success   += $result->success_count();
            $total_failed    += $result->failure_count();
            $total_attempted += $result->total_count();
            # print summary for each plan
            printf "    %10f s | %-50s | %10s | %10s | %10s\n", 
                  $result->duration(), $result->plan_name(), $result->success_count, 
                  $result->failure_count(), $result->failed_percent();
        }

        # print overall summary row
        my $total_percent = 0;
        $total_percent = sprintf "%2.2f", (100 * $total_failed/($total_attempted)) unless $total_attempted == 0;
        printf "    %10f s | %-50s | %10s | %10s | %10s\n", $total_duration, "TOTAL", $total_success, $total_failed, $total_percent;
        printf "\n\n";

        if ($total_failed > 0) {
            print "FAILED.\n\n";
        } else {
            print "all tests passed.\n\n";
        }


        return $total_failed;
    }

}
