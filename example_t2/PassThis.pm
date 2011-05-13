use MooseX::Declare;

class PassThis {

    use Method::Signatures::Simple name => 'action';
    # TODO: how about inheritance instead, reduce some boilerplate
    use Procrustes::TestPlan;


    action plan() {

        return Procrustes::TestPlan->new()->describe("Testing good stuff", [
            "This should work", sub {
                return 1;
            },

            "This should also work", sub {
                return 1;
            },
        ]);

    }

}
1;
