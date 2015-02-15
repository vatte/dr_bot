use utf8;
use Algorithm::MarkovChain;
use Switch;

my @horinaa = ("tuntuu", "hullulta");

my $max_words = 1000;

my $min_words = 10;

my $ala_horista;

my $longest = 4;

my $frequency = 1;

my $chain = Algorithm::MarkovChain::->new();

sub horise {
    my ($tag, $target) = split(/\|/, join(" ", @_));
    my $server = Irssi::server_find_tag($tag);
    if ( scalar @horinaa >= $min_words ) {
        $chain->seed(symbols => \@horinaa, longest => $longest );
        my $horinan_pituus = int(rand(19)) + 1;
        my @horina = $chain->spew(length => $horinan_pituus);
        $server->command("MSG $target @horina"); 
    }
    else {
        Irssi::print("horinaa on vain: " . scalar @horinaa . ", ja min_words on $min_words");
    }
    my $horistaan_taas = int(rand(14400000)) + 20000;
    $horistaan_taas = $frequency * $horistaan_taas;
    Irssi::print("horinan pituus: $horinan_pituus, horistaan taas: $horistaan_taas");
    $ala_horista = Irssi::timeout_add_once($horistaan_taas, "horise", "$server->{tag}|$target");
}

#the public commands

sub bootstrap {
    my ($server, $msg, $nick, $address, $target) = @_;

    my $horistaan_taas = int(rand(7200000)) + 1800000;
    
    if (index($msg, "horinaa") != -1) {
        $horistaan_taas = 5000;
    }
    elsif(($nick eq "om" ) && ( $target eq "#testataanbottiakohta" ) ) {
        @words = split(' ', $msg);
        $flag = @words[0];
        if ($flag eq "longest") {
            $longest = @words[1];
            $server->command("MSG $target longest on nyt $longest");
        }
        elsif($flag eq "frequency") {
            $frequency = @words[1];
            $server->command("MSG $target frequency on nyt $frequency");
        }
        elsif($flag eq "min_words") {
            $min_words = @words[1];
            $server->command("MSG $target min_words on nyt $min_words, ja horinaa on " . scalar @horinaa);
        }
        else {
            $server->command("MSG $target tuntematon komento");
        }
    }
    elsif(($nick eq "dr_dom" ) && ( $target eq "#terassillekohta" ) ) {
        @words = split(' ', $msg);
        push @horinaa, @words;
        while(length(@horinaa) > $max_words ) {
            shift @horinaa;
        }
        $horistaan_taas = 300000 + int(rand(1800000));
    }
    Irssi::timeout_remove($ala_horista);
    $horistaan_taas = $frequency * $horistaan_taas;
    $ala_horista = Irssi::timeout_add_once($horistaan_taas, "horise", "$server->{tag}|$target");
}

Irssi::signal_add_last('message public', 'bootstrap');

