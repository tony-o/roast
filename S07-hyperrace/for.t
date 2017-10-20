use v6;
use Test;

plan 6;

{
    my \rs = (^10000).race.map(* + 1);
    my $main-thread = $*THREAD.id;
    my $saw-another-thread = False;
    for rs {
        $saw-another-thread = True if $*THREAD.id != $main-thread;
    }
    nok $saw-another-thread, 'Plain for loop sequentially iterates a RaceSeq';
}

{
    my \hs = (^10000).hyper.map(* + 1);
    my $main-thread = $*THREAD.id;
    my $saw-another-thread = False;
    for hs {
        $saw-another-thread = True if $*THREAD.id != $main-thread;
    }
    nok $saw-another-thread, 'Plain for loop sequentially iterates a HyperSeq';
}

{
    my \rs = (^10000).race.map(* + 1);
    my $main-thread = $*THREAD.id;
    my $saw-another-thread = False;
    $saw-another-thread = True if $*THREAD.id != $main-thread for rs;
    nok $saw-another-thread, 'Plain postfix for loop sequentially iterates a RaceSeq';
}

{
    my \hs = (^10000).hyper.map(* + 1);
    my $main-thread = $*THREAD.id;
    my $saw-another-thread = False;
    $saw-another-thread = True if $*THREAD.id != $main-thread for hs;
    nok $saw-another-thread, 'Plain postfix for loop sequentially iterates a HyperSeq';
}

{
    my $main-thread = $*THREAD.id;
    my $saw-another-thread = False;
    race for ^10000 {
        $saw-another-thread = True if $*THREAD.id != $main-thread;
    }
    ok $saw-another-thread, 'A race for loop runs the body over threads';
}

{
    my $main-thread = $*THREAD.id;
    my $saw-another-thread = False;
    hyper for ^10000 {
        $saw-another-thread = True if $*THREAD.id != $main-thread;
    }
    ok $saw-another-thread, 'A hyper for loop runs the body over threads';
}
