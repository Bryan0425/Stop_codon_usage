#!/usr/bin/perl -w

open IN, $ARGV[0]; #stop codon fasta
open OUT, ">$ARGV[1]";

$/=">";
$taa = 0;
$tag = 0;
$tga = 0;
$other = -1;
while(<IN>){
	if($_ =~ /TAA/){
	$taa += 1;
	}if($_ =~ /TAG/){
	$tag += 1;
	}if($_ =~ /TGA/){
	$tga += 1;
	}else{
	$other += 1;
	}
	}
$total = $taa + $tag + $tga + $other;
$denominator = $total - $other;
$r1=$taa/$denominator*100;
$r2=$tag/$denominator*100;
$r3=$tga/$denominator*100;

print OUT "TAA:$taa\t$r1\nTAG:$tag\t$r2\nTGA:$tga\t$r3\nother:$other\ntotal:$total\n";

close IN;
close OUT;
