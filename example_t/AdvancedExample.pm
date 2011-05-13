# this example shows how to use simple closures in the event you want to reuse
# computations between tests.  Setup and teardown are also (minimally) used

use MooseX::Declare;

class AdvancedExample extends Procrustes::TestPlugin {

    use Procrustes::TestPlan;
    use Method::Signatures::Simple name => 'action';

    has counter => (isa => 'Int', is => 'rw', default => 1);
    has xyz     => (isa => 'Int', is => 'rw', default => 1);
    has abc     => (isa => 'Int', is => 'rw', default => 1);

    # this runs before each test case
    action setup() {
        $self->counter($self->counter() + 1);
    }

    # this runs after each test case
    action teardown() {
        $self->abc(1);
    }

    action plan() {
        
        $self->describe("Advanced Example...", [

            "Something with side effects", sub {
                $self->xyz(3); # no code is set to change this back at all
                $self->abc(4); # teardown will set this back to 1
                return 1;
            },

            "Setup can affect state", sub {
                # setup() function increments this counter before each test case is invoked
                return $self->is_equal($self->counter(), 3);
            },

            "Test cases can share state", sub {
                # this was set by the first test case
                return $self->is_equal($self->xyz(), 3);
            },

            "Teardown resets variables", sub {
                # this was cleared immediately after the first test case
                return $self->is_equal($self->abc(), 1);
            },

        ]);

   }

}

1;
