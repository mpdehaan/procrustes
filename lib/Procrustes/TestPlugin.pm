use MooseX::Declare;

class Procrustes::TestPlugin {

    use Method::Signatures::Simple name => 'action';

    action plan() {
        die "override me to define a plan";
    }

    action setup() {
    }

    action teardown() {
    }

    action describe($name, $coderefs) {
         return Procrustes::TestPlan->new()->describe($name, $coderefs);
    }

    # comparison info that produces output info only on failure
    # entirely optional!
    # we could use some more of these.
    action is_equal($a, $b, $should_match) {
        $should_match = 1 if not defined $should_match;
        if (($should_match) && (($a <=> $b) != 0)) {
            print "          equality comparison failed: $a != $b\n";
            return 0;
        }
        if ((! $should_match) && (($a <=> $b) == 0)) {
            print "          equality comparison failed: $a == $b\n";
            return 0;
        }
        return 1;
    }

}
