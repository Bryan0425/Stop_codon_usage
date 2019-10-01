# Stop_codon_usage

# Bo Pan
# 1st Oct, 2019
# bopan@stu.ouc.edu.cn
# Comparative genomics analysis of ciliates provides insights on the evolutionary history within "Nassophorea-Synhymenia-Phyllopharyngea" assemblage

READ ME
This series of workflow and scripts is suitable for finding the frequency of stop codon usage from RNA-seq(transcripts). 
The process is as follows:

1. Blastx search:
Search the peptides from Uniprot database (completed proteins sequences, not partial) with mRNA(transcripts) sequences by blastx.
e.g. blastx -db uniprot-ciliate-filter.fna -outfmt 6 -evalue 1.0e-10 -max_target_seqs 1 -num_threads 16 -query T_thermophila_transcripts.fasta -out T_thermophila_blast_pro.tab
2.给blast结果做标记正负链以及比对上的长度（终止子比对到蛋白的末端）
2. Mark the results:
Mark results with the watson and crick strands and the length of alignment (for next step to filter)
e.g. perl add_pro_len_and_plus_sus2blast_20180627.pl uniprot-ciliate-filter.fasta T_thermophila_blast_pro.tab T_thermophila_blast_pro_add_len.tab
3. Filter:
Select the sequences that is aligned to the end of the proteins, with an identity more than 30 and number of amino acids more than 50.
e.g. awk '{if($10==$13&&$3>=30.000&&$4>50)print$0}' T_thermophila_blast_pro_add_len.tab > T_thermophila_blast_pro_aa_end.txt
4. Extract targeted transcripts sequences:
Obtain the sequences of the targeted species from the former alignments.
e.g. perl 01_generate_matched_seqs.pl -i T_thermophila_June2014_CDS.fasta -l T_blast_pro_aa_end.txt -o T_matched.fa
5. Obtain the stop codon usage:
perl 02_generate_stop_codon_seqs.pl -i T_matched.fa -l T_blast_pro_aa_end.txt -o T_stop_codon.fa
6. Count the frequency of three types of stop codon usage:
perl 03_frequency_stop_codon.pl T_stop_codon.fa T_frequency_stop_codon.txt
