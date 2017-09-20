#! /usr/bin/perl -w
use strict;
use XML::Simple;
use Data::Dumper;
use utf8;
use File::Basename;
use File::Slurp;

my $usage = "
$0 <xml_subor> <html_subor>
";

my $xmlfile = shift or die $usage;
my $htmlfile = shift or die $usage;

my $pocetStlpcov = 6;

my $ref = XMLin($xmlfile) or die "Cannot read XML file $xmlfile";
my $out;
open( $out, ">:encoding(UTF-8)",$htmlfile) or die "Cannot open $htmlfile for writing";

my $sp = $ref->{'studijnePlany'}{'studijnyPlan'};

my $bloky = stiahni_bloky($sp);

foreach my $blok (@{$bloky}) {
    vypis_blok($out,$blok);
}

close $out;

sub stiahni_bloky {
    my ($ref) = @_;

    my @bloky;
 
    my $castisp = aoe($ref->{'castiStudijnehoPlanu'}{'cast'});
    foreach my $cast (@{$castisp}) {
	my $nazov_casti = $cast->{'nazov'};
	my $poznamkypredcastou = join("<br>",@{aoe($cast->{'obmedzenie'}{'poznamkyPred'}{'poznamkaPred'})});
	my $poznamkyzacastou = join("<br>",@{aoe($cast->{'obmedzenie'}{'poznamkyZa'}{'poznamkaZa'})});

	my $sutypy; my $typyvyucby;
	if (exists $cast->{'typyVyucby'}) {
	    $typyvyucby = aoe($cast->{'typyVyucby'}{'typ'});
	    $sutypy = 1;
	} else {
	    $typyvyucby = [ $cast ];
	    $sutypy = 0;
	}
	
	foreach my $typ (@{$typyvyucby}) {
	    my $nazov_typu = $typ->{'nazov'};
	    my $skratka_typu = $typ->{'skratka'};
	    my $poznamkypredtypom = join("<br>",@{aoe($typ->{'obmedzenie'}{'poznamkyPred'}{'poznamkaPred'})});
	    my $poznamkyzatypom = join("<br>",@{aoe($typ->{'obmedzenie'}{'poznamkyZa'}{'poznamkaZa'})});

	    my $dalsie_bloky = aoe($typ->{'bloky'}{'blok'});
	    foreach my $blok (@{$dalsie_bloky}) {
		if ($sutypy) {
		    $blok->{'comment'} = "$nazov_casti / $nazov_typu";
		} else {
		    $blok->{'comment'} = "$nazov_casti";
		}
		$blok->{'ppc'} = $poznamkypredcastou;
		$blok->{'pzc'} = $poznamkyzacastou;
		if ($sutypy) {
		    $blok->{'skratka_typu'} = $skratka_typu;
		    $blok->{'ppt'} = $poznamkypredtypom;
		    $blok->{'pzt'} = $poznamkyzatypom;
		}
		push (@bloky,$blok);
	    }
	}
    }

    return \@bloky;
}

sub vypis_blok {
    my ($out,$ref) = @_;

    my $blokypredmetov = aoe($ref->{'predmety'});
    my $predmety;
    foreach my $bp (@{$blokypredmetov}) {
	my $cp = aoe($bp->{'predmet'});
	push(@{$predmety},@{$cp});
    }
    foreach my $predmet (@{$predmety}) {
	vypis_predmet($out,$predmet);
    }
}

sub vypis_predmet {
    my ($out,$ref) = @_;

    my ($kod,$subor) = uprav_kod($ref->{'skratka'});
    my $suspendovany = soe($ref->{'aktualnost'});
    return if $suspendovany;

    my $dir = dirname($htmlfile);
    my $csv = read_file( ($dir ? "$dir/" : "") . "$subor.csv",
			 binmode => ':utf8');
    print $out $csv;
}

sub uprav_kod {
    my ($kod) = @_;

    if ($kod =~ /^([^\/]*FMFI[^\/]*)\/([^\/]*)\/(\d*)$/) {
	return ("$2/$3","$2_$3");
    } else {
	my $subor = $kod;
	$subor =~ s/\//_/g;
	return ($kod,$subor);
    }
}

sub soe {
    # string or empty
    my ($what) = @_;

    if (ref $what eq ref {}) {
	return "";
    } elsif (defined $what) {
	return $what;
    } else {
	return "";
    }
}

sub aoe {
    # array or else
    my ($ref) = @_;

    my @newref;
  
    if (ref $ref eq ref []) {
	return $ref;
    } elsif (defined $ref) {
	push(@newref,$ref);
	return \@newref;
    } else {
	return \@newref;
    }
}
