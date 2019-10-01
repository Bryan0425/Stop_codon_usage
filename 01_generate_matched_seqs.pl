#!/usr/bin/perl -w
use strict;
use Getopt::Long;
my ($infile,$outfile,$list,$help);
GetOptions(
        "i|input=s"=>\$infile,
        "l|list=s"=>\$list,
        "o|out=s"=>\$outfile,
        "h|help:s"=>\$help,
);
($infile && -s $infile)||$help||die & Usage();

open LS, $list || die "Can't open file $list!";
my %listids;
while (<LS>){
        chomp;
        my @line = split("\t", $_);
        $listids{$line[0]}=1;  #blast的query id作为key
}
close LS;
$/=">";  #结合后面if和哈希输出seqs
open IN, $infile||die $!;
<IN>;
open OUT,">$outfile"||die $!;
while(<IN>){
        chomp;
        s/^\s+//g;

        my $id;
        $id=$1 if(/^(\S+)/);  #ID后面有\n，所以只匹配到id

        print OUT ">$_",if($listids{$id});

}
close IN;

$/="\n";

sub Usage{
        my $info="
        Usage:perl $0 -i <infile> -l <genlist> -o <outfile>
Options:
        -i|input <str> set input fa file
        -l|list <str> inputfa id list seperated by '\\n' eg:ID\tend
        -o|out <str> set outfile for matched transcripts fasta file
        -h|help set outfile file
";
        print $info;
        exit 0;
}
