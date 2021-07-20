#species_select_octo.pl

use strict;
use warnings;
use Time::HiRes qw(time);

my $start_run = time();
my $filename = 'MP_file_list.txt';
my @results =();
my @files = ();
my $count = 0;
my $length = 0;

open (FH1, '<', $filename) or die "cannot open $filename $!";
while (my $line = <FH1>) { 
	chomp $line;
	$line =~ s/^\s+|\s+$//g;
	push (@files, $line);
}
print "@files\n";
close FH1;

my @mers = ('GTACGCCA','ATCCGGAT','GTCCGCTG','AGGCGTAC','TGGCGTAC','TATCGACA','CAACGATC','AGACGATA','AGACGTAC','GATCGACC','GATCGTAG','GATCGAGC','CATCGACC','GTTCGACC','GATCGATC','GTTCGAAC','TATCGATC','AATCGATC','ATTCGAAC','GATCGGCA','TGCCGATC','GATCGGCA','TGGCGATC','TTGCGCCA','AGGCGATC','CATCGAAC','CATCGTTG','AATCGCCA','GTGCGTCC','TGGCGAGG','ACACGAGG','CCACGTGT');

foreach (@files) {
	my $filen = $_;
	push (@results, "\n\n$filen\n");
	open (FH4, '<', $filen) or die "cannot open $filen\n";
	while (my $line2 = <FH4>) { 
		$length++ while $line2 =~ /[C,T,G,A]/g;
	}	
	push (@results, "Length: $length\n");
	close FH4;
	$length = 0;
	foreach (@mers) { 
		open (FH, '<', $filen) or die "cannot open $filen\n";
		my $iteration = $_;
		$count = 0;	
		push (@results, "$iteration\t");
		while (my $line2 = <FH>) { 
			chomp $line2;
			$count++ while $line2 =~ /$iteration/g;
		}
		push (@results, "$count\n");
	}	
}

open (FH2, '>>', 'PP_species.txt') or die "cannot open $filename\n";
print FH2 "@results\n";

my $end_run = time();
my $run_time = $end_run - $start_run;
print "\n";
print "Job took $run_time seconds\n";

exit;
