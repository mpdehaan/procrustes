use MooseX::Declare;

class PassThis extends Procrustes::TestPlugin {

    use Method::Signatures::Simple name => 'action';
    # TODO: how about inheritance instead, reduce some boilerplate
    use Procrustes::TestPlan;


    action plan() {

        return $self->describe("Testing good stuff", [
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
