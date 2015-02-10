use WWW::Wikipedia;
use utf8;

#http://stackoverflow.com/questions/7863746/perl-irssi-scripting-how-to-send-msg-to-a-specific-channel
#name of the channels where this feature will be used
my %channels = { "#terassillekohta" => 1, "#testataanbottiakohta" => 1, "!inkubio" => 1};

my @sentences = (
    "tuntuu hullulta",
    "melkosta tarinaa!",
    "(troll warning päällä)",
    "onko siellä jo yö?",
    "osui ja upposi!",
    "katotaan miten se kone pelaa ja on!",
    "kantohommissa",
    "ei mulla tää ajokunto ookaan",
    "vuoroesimies huusi jo kaukaa",
    "ajojahti!",
    "hain eväät hesburgerista",
    "täälä painetaan hommia että espanjan pankit saa rahaa!",
    "nyt nussitaan!",
    "huhhuh",
    "(:))",
    "mittee työ?"
);

my $frequency = 50; #say something with 1/frequency probability

my $wikipedia = WWW::Wikipedia->new(language => 'en');


#the public commands

sub bootstrap {
    my ($server, $msg, $nick, $address, $target) = @_;
    #lowercase of the channel name in case this one will be registered in camelCase ;)
    $target = lc $target;

    my $ownNick = $server->{nick};

    #wait a bit to appear more natural
    #sleep(int(rand(5)) + 1);

    # charset are the shit
#    if ($msg =~ /^mikÃ¤ on (\w+)?/i) {
#        my $wikipedia = WWW::Wikipedia->new(language => 'en');
#        my $entry = $wikipedia->search($1);
#        if ($entry) {
#            $server->command("MSG $target found: " . $entry->text());
#        }
#        return;
#    }

    # old code
#    if (%channels->{$target}) {
        #wait a bit to appear more natural
        sleep(int(rand(5)) + 1);

        if (index($msg, $ownNick) != -1) {
	        @words = split(' ', $msg);
            $whatword = @words[int(rand(@words))];
            if( index( $whatword, $ownNick ) != -1 ) {
                $server->command("MSG $target $nick: sitä just.");
	        } else {
                 $kontti = "";
                 for($i = 1; $i < @words; $i++) {
                     $word = @words[$i];
                     $word =~ s/\p{Punct}//g;
                     $word =~ m/[cdfghjklmnpqrstvwxyz]/;
                     $index = $-[0];
                     if($index == 0) {
                         $tmp = substr($word, 1);
                         $tmp =~ m/[cdfghjklmnpqrstvwxyz]/;
                         $index = $-[0] + 1;
                         if($-[0] == 0) {
                              $tmp = substr($tmp, 1);
                              $tmp =~ m/[cdfghjklmnpqrstvwxyz]/;
                              $index = $-[0]+2;
                         }
                         if($index == 0){
                              $index = length($word);
                         }

                     }                          


                     $beginning = substr($word, 0, $index);
                     $ending = substr($word, $index);
                     $kontti = $kontti . "ko" . $ending . " " . $beginning . "ntti ";
                 }
                 $server->command("MSG $target $nick: $kontti");

#                    $whatword =~ s/\p{Punct}//g;
#                    if(index($msg, 'jo') != -1) {
#                        $server->command("MSG $target $nick: ai vasta $whatword?");
#                    }
#                    elsif(index($msg, 'vasta') != -1) {
#                        $server->command("MSG $target $nick: eiku $whatword jo!");
#                    }
#                    else {
#                        $server->command("MSG $target $nick: mitä " . $whatword . "kin nyt on");
#                    }
            }
        } else {
            $whattodo = int(rand( $frequency * @sentences ));
            if( $whattodo < @sentences ) {
                $server->command("MSG $target @sentences[$whattodo]");
            }
        }
#     }
}

sub private_msg {
    my ($server, $msg, $nick, $address) = @_;
    if( $nick eq "om" ) {
        $server->command("MSG #testataanbottiakohta $msg");
    }
    if( $nick eq "dr_dom" || $nick eq "hu1" ) {
        $server->command("MSG #terassillekohta $msg");
    }
}


Irssi::signal_add_last('message public', 'bootstrap');
Irssi::signal_add_last('message private', 'private_msg');
