# Deduper - Maura Kautz

## Deduper Part 1 - Pseudocode

### October 15, 2024

- Beginning Deduper assignment by writing pseudocode. Began by outlining goals from the [README.md](README.md) provided by Leslie

- Created example input and output files. Changed the SO to coordinate because these files are supposed to be sorted, not unsorted. In the test file the SO is unsorted. Input file has duplicates of certain lines and the output file removed the duplicates.

### October 16, 2024

- Drawing pseudocode diagram on iPad

- Worked with Lauren and Abraham to map out rest of pseudocode on white board.
    see [Part_1/pseudocode.md](Part_1/pseudocode.md)

### October 28, 2024

- Added argparse arguments that were outlined in [README.md](README.md)

- Created new conda envrionment in Deduper-MauraKautz

    `conda create -n Dedupe`

    `conda activate Dedupe`

- Installing samtools using `conda install samtools` in Dedupe environment to be able to use samtools to sort the sam file (deduper code will only run on a *sorted* sam file)
    - samtools version 1.21


### November 11, 2024

- Did work on Novemeber 3, but decided I didn't like the layout, so starting over using functions instead of just a bunch of statements

- Decided to create a function for each thing that needed to happen for deduper, except for the actual deduping:

    - `load_umis`

        Will take a file of known UMIs (unique molecular index, indicated by -u flag) and create a set (stores multiple items in single variable) to check UMIs in each line, making sure that they're known.

    - `find_strand`

        Will look at the bitwise flag in element 2 of a samline and determine whether the read for that samline is on the plus or minus strand.

    - `adjusted_pos`

        Will take the CIGAR string and position from samline and adjust samline starting position for softclipping, matching, alginment gaps, deletions, and insertions.

    - `parse_sam_line`

        Will take one line from a SAM file and pull all necessary information for checking uniqueness: UMI, chromosome, plus/minus strand, position, CIGAR string. Stored in a tuple.

- Intialized known umi set, chromosome iterator and dictionary to run through the file one chromosome at a time, a dictionary for unique reads, and counters for the number of unknown umis found in the file and duplicates removed:

        umi_set = load_umis(u)
    
        current_chrom = None
    
        chrom_dict = {}
    
        unique_dict = {}
    
        unknown_umi = 0
    
        removed_dups = 0

- Final loop in code runs through one function at a time.  First, the input sam file is opened to be read one line at a time. If the line is empty, add the last chromosome to it's respective dictionary and then break. This adds the final chromosome instead of ignoring it when the end of the file is reached. Next, header lines (starting with @) are written to the output file. `UMI, chrom, strand, pos, cigar` are set equal to the line. If the UMI is not in the known set, add one to the `unknown_umi` counter. If the line is from the reverse strand or the forward strand with soft clipping, the position is adjusted using `adjusted_pos`. `samline_ID` is set as a variable to hold all information needed to determine whether the read is unieuq or not. If the chromosome in the ID is equal to the `current_chrom` and if the `samline_ID` is not already in  the `chrom_dict`, then the line is added, otherwise the `removed_dups` counter is increased by one. After checking for duplicates, the read will then be added to the `unique_dict`. For each new chromosome, the `chrom_dict` will be cleared.

- Used `samtools sort -o` to sort the full data file found at `/projects/bgmp/shared/deduper/C1_SE_uniqAlign.sam`

- Created a slurm script to run [kautz_deduper.py](kautz_deduper.py) so that I could see the amount of memory and time it took. Used print statements and bash commands to answer all questions required in survey

- Bash Commands:

    For counting the number reads matched to each chromosome in chrom \t count structure:

    `awk '$1 !~ /^@/ {print $3}' deduped_results.sam | sort | uniq -c | awk '{print $2, $1}' | sort -k1,1V > chrom_count.tsv`

    For counting the number of header lines:

    `grep '^@' deduped_results.sam | wc -l`

    For finding the total unique reads (subtracted header lines from this ooutput):

    `wc -l deduped_results.sam`

**Final Results**

Time Elapsed: 1:15.86

Memory Used: 7.5 GB

Number of Header Lines: 65

Number of Unique Reads: 13748094

Number of Wrong UMIs: 0

Number of Duplicates Removed: 4438339

Number of Reads Mapped to Each Chromosome:

1     698138

2    2788129

3     548220

4     590301

5     562589

6     511282

7     1119160

8     577080

9     627237

10     565793

11     1228239

12     360226

13     467891

14     387402

15     438124

16     360903

17     518840

18     290921

19     572382

X     318253

Y     2247

MT     208095

GL456210.1     4

GL456211.1     5

GL456212.1     3

GL456221.1     3

GL456233.2     655

GL456367.1     2

GL456368.1     2

GL456370.1     20

GL456379.1     1

GL456396.1     16

JH584295.1     111

JH584299.1     2

JH584304.1     293

MU069434.1     2

MU069435.1     5458

