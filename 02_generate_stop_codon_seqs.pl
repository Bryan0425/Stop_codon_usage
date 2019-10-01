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
open FASTA, $infile|| die "Can't open file $infile!";
open OUT, ">$outfile"|| die "Can't open file $outfile!";;
my %fasta;
my $scf;
while (<FASTA>){
        
        if (/^\>(.+?)[\r\n\s\t]/){
                $scf=$1;
                #print "$scf\n";
                next;
        } else {
                $_ =~ s/[\r\n\s\t]//g;
                $fasta{$scf} .= $_;
                #print "$scf\n";
                }
                }
close FASTA;

while (<LS>){
        chomp;
        my @line2 = split("\t", $_);

        if($_=~/\+/){

        if (length($fasta{$line2[0]}) >= ($line2[7]+3)){  #new
        my $specific_seqs = substr("$fasta{$line2[0]}", $line2[7], 3);

        print OUT "\>$line2[0]\n$specific_seqs\n";
      
        }  #new
        }else{  # match "-"

        if (($line2[7]-1)>=3){  #new

        my $tmp_seqs = substr("$fasta{$line2[0]}", 0 , $line2[7]-1);
        my $new_seqs = reverse $tmp_seqs;

        my $specific_seqs = substr($new_seqs,0 , 3);

       
        $specific_seqs =~ tr/ATCG/TAGC/;
    
        print OUT "\>$line2[0]\n$specific_seqs\n";
    
        }  #new
        }
}

close LS;
close OUT;

sub Usage{
        my $info="
        Usage:perl $0 -i <infile> -l <genlist> -o <outfile>
Options:
        -i|input <str> set input fa file
        -l|list <str> inputfa id list seperated by '\\n' eg:ID\tend
        -o|out <str> set outfile for stop codon fasta file
        -h|help set outfile file
";
        print $info;
        exit 0;
}
