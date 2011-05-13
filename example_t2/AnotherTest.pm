use MooseX::Declare;

class AnotherTest {

    use Procrustes::TestPlan;
    use Method::Signatures::Simple name => 'action';

    sub plan() {
        
        return Procrustes::TestPlan->new()->describe("Another test suite...", [

            "This is doomed to fail", sub {
                return 2 == 3;
            },

            "This should work", sub {
                sleep(2);
                return 1;
            },
 
            "This won't work", sub {
                die "kaboom!\n"
            },

        ]);

   }

}

1;
