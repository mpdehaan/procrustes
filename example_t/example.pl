use Procrustes;

my $tester = Procrustes->new();
$tester->test([

    "Here's something that returns false", sub {
        return 2 == 3;
    },

    "Something that returns true", sub {
        return 1;
    },

    "Something that takes a while", sub {
        sleep(3);
        return 1;
    },

    "Something that raises an exception", sub {
        die "boom";
    },

])->report();
