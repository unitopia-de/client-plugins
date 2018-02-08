package unitopiasound;
#: Version: 1.0
#: Description: Plays the Sounds sent via GMCP
#: Author: Gnomi@UNItopia.de

use File::Basename;
use File::Fetch;
use File::Path;

use strict;

$::world->hook('OnServerData', '/unitopiasound::receive()', { name => 'Play sound for UNItopia' });

my $baseurl = undef;

sub help
{
    $::world->echonl("Listens for a GMCP message to play a sound.");
    $::world->echonl("Just load the plugin and it will activate at MUD login.");
}

sub receive
{
    return unless $::server_data{'protocol'} eq 'GMCP';

    my $pkg = lc($::server_data{'package'});
    return unless $pkg =~ /^(sound|core)$/;

    my $msg = lc($::server_data{'message'});

    if ($pkg eq 'core')
    {
        if ($msg eq 'hello')
        {
            $::world->sendserverdata({
                protocol => 'GMCP',
                package => 'Core',
                subpackage => 'Supports',
                message => 'Add',
                data => [ "Sound 1" ]
            });
        }
    }
    elsif ($pkg eq 'sound')
    {
        if ($msg eq 'url')
        {
            $baseurl = $::server_data{'data'}->{'url'};
        }
        elsif ($msg eq 'event')
        {
            playsound($::server_data{'data'}->{'file'});
        }
    }
}

sub DISABLE
{
    $::world->sendserverdata({
        protocol => 'GMCP',
        package => 'Core',
        subpackage => 'Supports',
        message => 'Remove',
        data => [ "Sound" ]
    });

    $::world->delhook('OnServerData', 'Play sound for UNItopia');

    $::world->echonl("Sound plugin deactivated.");

    return 1;
}

sub ENABLE
{
    $::world->hook('OnServerData', '/unitopiasound::receive()', { name => 'Play sound for UNItopia' });

    $::world->sendserverdata({
        protocol => 'GMCP',
        package => 'Core',
        subpackage => 'Supports',
        message => 'Add',
        data => [ "Sound 1" ]
    });

    $::world->echonl("Sound plugin activated..");

    return 1;
}

sub pathconcat
{
    my $result = shift;

    while (my $element = shift)
    {
       $result .= '/' if (substr($element, 0, 1) ne '/' and substr($result, length($result)-1, 1) ne '/');
       $result .= $element;
    }

    return $result;
}

sub playsound
{
    return unless defined($baseurl);

    my $fileurl = pathconcat($baseurl, shift);

    my $filename = $fileurl;
    $filename =~ s/.*:\/\///;
    $filename = pathconcat($ENV{'HOME'}, '.kildclient/sounds', $filename);

    my $directory = dirname($filename);
    mkpath($directory);

    my $downloader = File::Fetch->new(uri => $fileurl);
    my $result = $downloader->fetch( to => $directory);

    ::play($result) if defined($result);
}
