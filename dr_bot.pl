#http://stackoverflow.com/questions/7863746/perl-irssi-scripting-how-to-send-msg-to-a-specific-channel
#name of the channels where this feature will be used
my @channels  = ("#terassillekohta", "#testataanbottiakohta", "!inkubio");

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

#the public commands
#own nick
my $ownnick = "dr_bot";

sub bootstrap {
    my ($server, $msg, $nick, $address, $target) = @_;
    #lowercase of the channel name in case this one will be registered in camelCase ;)
    $target = lc $target;

    #wait a bit to appear more natural
    sleep(int(rand(5)) + 1);

    foreach my $channel (@channels) {
        if ( $target eq $channel) {
            if (index($msg, $ownnick) != -1) {
		@words = split(' ', $msg);
                $whatword = @words[int(rand(@words))];
                if( index( $whatword, $ownnick ) != -1 ) {
                    $server->command("MSG $target $nick: sitä just.");
		}
                else {
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
            }
            else {
                $whattodo = int(rand( $frequency * @sentences ));
                if( $whattodo < @sentences ) {
                    $server->command("MSG $target @sentences[$whattodo]");
                }
            }
         }
     }
}

sub private_msg {
    my ($server, $msg, $nick, $address) = @_;
    if( $nick eq "om" ) {
        $server->command("MSG #testataanbottiakohta $msg");
    }
    if( $nick eq "dr_dom" ) {
        $server->command("MSG #terassillekohta $msg");
    }
}


Irssi::signal_add_last('message public', 'bootstrap');
Irssi::signal_add_last('message private', 'private_msg');
