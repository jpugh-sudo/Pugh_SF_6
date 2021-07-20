#MCE_octo.pl

use strict;
use warnings;

use Time::HiRes qw(time);
use MCE::Grep;
use MCE::Loop;


my $start_run = time();

my $count = 0;
my $update = 0;
my $line = 0;
my @results = "\n";

my @fl = glob '{T,A,C,G}{T,A,C,G}{T,A,C,G}CG{T,A,C,G}{T,A,C,G}{T,A,C,G}'; 
#makes an array of all possible CpG+ octamers

my $filename = 'prot.fasta';
#the genomic dataset to open

print "$filename\n";

{
open(FH, '<', $filename) or die "cannot open $filename\n"; 
local $/ = undef;
$line = <FH>;
}
#reads the genomic data into memory

mce_loop { do_work($_) for (@{ $_ }) } \@fl;	
# the central command of the program: runs the sub with multi-thread

sub do_work {
	$count++ while $line =~ /$_/g;
	print join(":",$_,$count),"\n";
	$count = 0;
}
# the sub to grep the CpG+ octamers 

my $end_run = time();
my $run_time = $end_run - $start_run;
print "\n";
print "Job took $run_time seconds\n";

exit;