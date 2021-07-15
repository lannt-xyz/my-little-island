#!/usr/bin/perl -w
use strict;
use File::Copy;

open (LOG, ">log.xls");
print LOG "xml filename\told filename\tnew filename\n";

my @input_files = glob ("*.xml");

foreach my $input (@input_files) {
	my $temp = "temp.xml";
	copy ($input, $temp);
	open (IN, '<:utf8', $temp);
	open (OUT, '>:utf8', $input);
	while (<IN>) {
		if ($_ =~ /CDATA\[(.*?\.[mspfj][wpnlp][f3gv])\]\]>/) {
			my $filename = $_;
			chomp $filename;
			$filename =~ s/.*CDATA\[(.*?\.[mspfj][wpnlp][f3gv])\]\]>.*/$1/g;
			print $filename . "\t";
			my $lc_filename = lc($filename);
			print $lc_filename . "\n";
			unless ($lc_filename eq $filename) {
				print LOG "$input\t$filename\t$lc_filename\n";
			}
			$_ =~ s/(CDATA\[).*?\.[mspfj][wpnlp][f3gv](\]\]>)/$1$lc_filename$2/g;
		}
		print OUT $_;
	}
	close IN;
	close OUT;
	unlink $temp;
}