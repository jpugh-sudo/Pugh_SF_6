#Find_NCBI.pl

use strict;
use warnings;
use WWW::Mechanize;

my $start_run = time();

my @fl =();
my @results =();
my $count = 0;

my $filename = 'Disease_match_ALL.txt';
my $repository = 'ALL_all_found_results.txt'; 
$/ = "\n";

open(FH, '<', $filename) or die "cannot open $filename\n"; 
while (my $line = <FH>) {
	chomp $line;
	push (@fl, $line);	
}		

foreach (@fl) {
	print "$_\t";
	push(@results, "$_\t");
	my $name1 = (split /\s/, $_)[0];
	my $name2 = (split /\s/, $_)[1];
	my $url = "https://www.ncbi.nlm.nih.gov/medgen/?term=${name1}+${name2}";
	my $mechanize = WWW::Mechanize->new(autocheck => 1);
	$mechanize->get($url);
	my $page = $mechanize->content;
	my $page1 = (split /\n/, $page)[10];
	print "$page1\n";
	push(@results, "$page1\n");
}

open(RESULTS, '>', $repository) or die "cannot open $repository\n"; 
print RESULTS "@results\n";

my $end_run = time();
my $run_time = $end_run - $start_run;
print "\n";
print "Job took $run_time seconds\n";

exit;