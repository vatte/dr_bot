use utf8;
use Algorithm::MarkovChain;

my %channels = { "#terassillekohta" => 1, "#testataanbottiakohta" => 1, "!inkubio" => 1};

my @horinaa = ("tuntuu", "hullulta");

my $max_words = 1000;

my $ala_horista; #= Irssi::timeout_add_once(5000, "horise", 0);

my $chain = Algorithm::MarkovChain::->new();

sub horise {
    my ($tag, $target) = split(/\|/, join(" ", @_));
    my $server = Irssi::server_find_tag($tag);
    $chain->seed(symbols => \@horinaa);
    my @horina = $chain->spew(length => 1);
    $server->command("MSG $target @horina"); 
    #my $horistaan_taas = 2000;
    my $horistaan_taas = int(rand(7200000)) + 20000;
    #my $horistaan_taas = int(rand(7200)) + 2000;
    #Irssi::print($horistaan_taas);
    $ala_horista = Irssi::timeout_add_once($horistaan_taas, "horise", "$server->{tag}|$target");
}

#the public commands

sub bootstrap {
    my ($server, $msg, $nick, $address, $target) = @_;

    my $horistaan_taas = 3600000;
    if(($nick eq "dr_dom" ) && ( $target eq "#terassillekohta" ) ) {
        @words = split(' ', $msg);
        push @horinaa, @words;
        while(length(@horinaa) > $max_words ) {
            shift @horinaa;
        }
        $horistaan_taas = 600000;
    }
    Irssi::timeout_remove($ala_horista);
    $ala_horista = Irssi::timeout_add_once($horistaan_taas, "horise", "$server->{tag}|$target");
}

Irssi::signal_add_last('message public', 'bootstrap');

