use MooseX::Declare;

class AnotherTest extends Procrustes::TestPlugin {

    use Procrustes::TestPlan;
    use Method::Signatures::Simple name => 'action';

    action setup() {
    }

    action teardown() {
    }

    action plan() {
        
        $self->describe("Another test suite...", [

            "Non zero return code should fail", sub {
                return 2 == 3;
            },

            "This will tell you why it is wrong", sub {
                return $self->is_equal(2,3);
            },

            "Inequality test will pass", sub {
                return $self->is_equal(2,3,0);
            },

            "This should work but takes 2 secs", sub {
                sleep(2);
                return 1;
            },
 
            "This will cause a traceback", sub {
                die "kaboom!\n"
            },

        ]);

   }

}

1;
