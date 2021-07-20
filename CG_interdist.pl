#CG_interdist.pl

use strict;
use warnings;
use Time::HiRes qw(time);

my $start_run = time();

my $filename = 'H_ssDNA.fasta';
my $repository = "${filename}_dist.txt";

my @fl= ();

my @results = ();

my %hash;

my @breaks;

print "\n\n$filename\n";
print "TG\n";

{
my $line = ();

{
open(FH, '<', $filename) or die "cannot open $filename\n"; 
local $/ = undef;
$line = <FH>;
}

close FH;

open(FH2, '>', $repository) or die "cannot open $repository\n"; 	

$line =~ s/\R//g; #get rid of newlines throughout;

while ($line =~ /CG/g) {
	push(@fl, "$-[0]\n"); #map CpG sites
} 
while ($line =~ />/g) {
	push(@fl, "$-[0].1\n");	#map FASTA file starts with a DECIMAL number (x.1)
}

undef $line;

}

@fl = sort {$a <=> $b} @fl; #numerically sort numbers representing CpG sites and numbers representing FASTA file starts


		
for (1..$#fl) {
	my $slope = ($fl[$_] - $fl[$_ -1])-2; #subtract pairs of mapped numbers, producing distances between CpG sites. Subtraction of a CpG and a the decimal number (start site) will produce a decimal difference. Differences with a decimal will be discarded because they are not real distances. However, they prevent recording a distance between the last CpG of one FASTA and the first CpG of the next FASTA. 
	push (@results, "$slope\n");
}


print FH2 "CG counts\n\n\n";	
$hash{$_}++ for @results; #make a hash of distances
my @matches = grep { /\./ } keys %hash; #find decimal differences 
delete @hash{@matches}; #get rid of decimal differences
for (sort keys %hash) {
	print FH2 "$_ -> $hash{$_}\n"; #print the sorted hash
}


my $end_run = time();
my $run_time = $end_run - $start_run;
print "\n";
print "Job took $run_time seconds\n";

exit;
