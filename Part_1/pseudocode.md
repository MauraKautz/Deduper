# Deduper Part 1

## Goal: 
Write up a strategy for writing a Reference Based PCR Duplicate Removal tool. That is, given a sorted sam file of uniquely mapped reads, remove all PCR duplicates (retain only a single copy of each read). Develop a strategy that avoids loading everything into memory.

- Define the problem
- Write examples:
    - Include a properly formated sorted input sam file
    - Include a properly formated expected output sam file
- Develop your algorithm using pseudocode
- Determine high level functions
    - Description
    - Function headers
    - Test examples (for individual functions)
    - Return statement

### Define the Problem: what is deduplicating and why is it done?
Deduplicating is used to remove artifical PCR duplicates that are not a representation of biological data. This is performed to improve data quality for downstream analyses and provide an accurate quanification of unqie reads.

### Write Examples:

- Sorted input sam file is located here: [input_sam.md](input_sam.md)

- Expected output sam file is located here: [output_sam.md](output_sam.md)

### Pseudocode Algorithm:

In python
```
set arguments:

    include the following argparse options
    - ```-f```, ```--file```: designates absolute file path to sorted sam file
    - ```-o```, ```--outfile```: designates absolute file path to deduplicated sam file
    - ```-u```, ```--umi```: designates file containing the list of UMIs
    - ```-h```, ```--help```: prints a USEFUL help message (see argparse docs)

initialize a dictionary:

    unique_reads = dict{}

convert file of known umis into a list to compare samfile umis to:

    u = list[]

start with a while True loop:

while True:
read in one line from file
    if the line is empty, break (reached end of file)
    if the line starts with "@", write to output file output.sam and continue (these are the header lines)
    split line by tabs to create tab delineated list of columns, save into LINE_LIST (need a tab separated list of values becuase we will be extracting certain columns later)

    
    UMI = last part of column 1 which is last 8 characters of (LINE_LIST[0])
    If UMI is in list of known UMIs, move on with rest of while True loop
    If UMI is NOT in list of known UMIs, continue to next line of SAM file

    extract RNAME (column 3) - this is the chromosome

    extract FLAG (column 2) - this is the bitwise flag
        if ((flag & 16)==16):
            strand = minus
        else:
            strand = plus

    extract POS (column 4) - this is the position in the chromosome

    extract CIGAR string (column 6) - shows if soft clipping occurs
        if CIGAR starts with nS (any number S):
            POS += n

    store UMI, RNAME, strand, adjusted POS in a list KEY_LIST

    if KEY_LIST is NOT in unique_reads, add it to the dictionary:
        else move on to the next line (this means it is a duplicate and we do not want to save it as another key) 
        #in this dictionary, the KEY_LIST values will be the keys, and the entire SAM file lines will be the values

write values of unique_reads to output.sam with header lines (@) stored earlier
```

### High Level Functions:

I am not going to use any high level functions because each instance of altering the unique key for a line in the SAM file only occurs once, there is no instance of changing the same type of value multiple times. For example, the position only needs to change one based off the CIGAR string.


