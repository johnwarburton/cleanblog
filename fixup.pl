#!/usr/bin/perl
use strict;
use warnings;

#
# Fix up the posterous to wrodpress export
#

#
# <a href="http://getfile8.posterous.com/getfile/files.posterous.com/temp-2012-0
8-03/AaFjbFGxJqequcjcJugzlzuyutEfscaCwhaimxjIbxJIAFjhhvIaDujiDuHy/IMG_1068.JPG.s
caled1000.jpg"><img alt="Img_1068" height="375" src=".scaled500.jpg" width="500"
 /
#
# 1. replace http:.*/IMG....JPG... with blog_images/IMG...JPG...
# 2. any src=".scaled500.jpg" insert IMG...JPG
# 3. replace href="http://192.168.1.100/wordpress with
# 4. Make links around the blog end in index.html

my (@line, $img_1000, $img_500);

if ($#ARGV != 0) {
  print "Supply a file name\n";
  exit 1;
}

my $INDEX = $ARGV[0];
open(INDEX, $INDEX) or die "Cannot open $INDEX for reading: $!\n";
while (<INDEX>) {

    $_ =~ s/^<base.*/<base href="file:\/\/\/\/\/Diskstation\/NAS\/blog\/" \/>/;

    $_ =~ s#http://192.168.1.100/wordpress/##g;
    $_=~ s/ldlionscopy/LD Lions 2012/g;
    $_=~ s/Just another WordPress site/A copy of the LD Lions 2012 Blog/g;
    $_ =~ s/href=\"\"/href=\"index.html\"/g;


    if ($_ !~ / href=/i) {
        print $_;
        next;
    }


    if ($_ =~ /getfile/) {

        @line = split('=', $_);
        #print "<<<<<< ", join("\n",@line ), "\n";
        ($img_1000) = ($line[1] =~ /.*\/(.*)/);
        ($img_500) = ($line[4] =~ /.*\/(.*)/);

        if ($line[1] eq '".scaled1000.jpg"><img alt') {
            # uncommon case 2
            $img_1000 = $img_500;
            $img_1000 =~ s/500/1000/g;
            $img_1000 =~ s/jpg\".*/jpg\"><img alt/;

        }
        $line[1] = "\"blog_images/" . $img_1000;

        ($img_500) = ($line[4] =~ /.*\/(.*)/);
        if ($line[4] eq '".scaled500.jpg" width') {
            # case 2
            $img_500 = $img_1000;
            $img_500 =~ s/1000/500/g;
            $img_500 =~ s/jpg\".*/jpg\" width/g;
        }
        $line[4] = "\"blog_images/" . $img_500;

        #print ">>>>>> $_\n";
        #print "<<<<<< ", join("\n",@line ), "\n";
                print join("=",@line );
    }
    elsif ($_ =~ /href=\"2012\/.*?\/\"/) {
#                 a href='2012/12/'
        # case 4
        $_ =~ s/(href=\"2012\/.*?\/)\"/${1}index.html\"/;
        print $_;

    }
    elsif ($_ =~ /href=\'2012\/.*?\/\'/) {
#                 a href='2012/12/'
        # case 4
        $_ =~ s/(href=\'2012\/.*?\/)\'/${1}index.html\'/;
        print $_;

    }
    else {
        print $_;
    }
}
close(INDEX);
