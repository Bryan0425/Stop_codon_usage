#!/usr/bin/perl -w
open IN1, $ARGV[0];  #pro fasta
open IN2, $ARGV[1];  #blast tab
open OUT, ">$ARGV[2]";  #blast format

my $id;
my $id_tab;
my %pro;
my @ar;
my $len;

while(<IN1>){
	if(/^\>(.+?)[\s\t\r\n]/){
	$id = $1;
	next;
	}else{
	$_ =~ s/[\r\n\t\s]//g;
	$pro{$id}.=$_;  #seqs
	}
	}
close IN1;

while(<IN2>){
	chomp;
	@ar = split("\t", $_);
	$id_tab = $ar[1];
	if ($pro{$id_tab}){
	$len = length($pro{$id_tab});  #len
	if($ar[6]>$ar[7]){  #blast query 分正负链
	print OUT "$_\t$len\t\-\n";
	}else{
	print OUT "$_\t$len\t\+\n";
	}
	}
	}
close IN2;
close OUT;
