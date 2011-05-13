use MooseX::Declare;

class Procrustes::TestPlugin {

    use Method::Signatures::Simple name => 'action';

    action plan() {
        die "override me to define a plan";
    }

}
