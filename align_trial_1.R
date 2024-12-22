# Initialize variables
ll <- character(length = 0)

# Define run identifiers
runs <- c(1, 2)  # Assuming two runs for simplicity

# File patterns for each set of samples
main_pattern <- "t1_.*_R[12]_.*_trimmed.fastq.gz"  # 68 samples
special_pattern <- "E[0-9]+_.*_R[12]_.*_trimmed.fastq.gz"  # 2 special samples

# Loop through each run
for (run in runs) {
  # Create command file for the run
  cmd_file <- paste("S01_Align_cmd_run", run, ".txt", sep = "")
  cat("", file = cmd_file)  # Clear/create the file
  
  # Set the directory containing the FASTQ files
  fastq_dir <- paste("/home/kingeg/Projects/RNA_SEQ_BasePop/Data/run", run, "/", sep = "")
  
  # Find all files matching the main pattern
  ffs_main <- list.files(fastq_dir, pattern = main_pattern, full.names = TRUE)
  
  # Find all files matching the special pattern
  ffs_special <- list.files(fastq_dir, pattern = special_pattern, full.names = TRUE)
  
  # Combine both file sets
  ffs <- c(ffs_main, ffs_special)
  
  # Process each file
  for (fastq_file in ffs) {
    # Extract base file name (without extension)
    base_name <- strsplit(basename(fastq_file), "_", fixed = TRUE)[[1]]
    sample_id <- paste(base_name[1], base_name[2], sep = "_")  # Extract sample ID
    
    # Define input and output paths
    st.s <- "hisat2 --dta -q -x /group/kinglab/enoch/MyGithub/BasePop_RNAseq/base_pop/indexes/bdgp6_tran/genome_tran -U "
    outf <- paste(
      "/group/kinglab/enoch/MyGithub/BasePop_RNAseq/base_pop/processed/dotsams/",
      sample_id, "_run", run, sep = ""
    )
    
    # Append command to the file
    cat(
      paste(st.s, fastq_file, " -S ", outf, ".sam", sep = ""),
      "\n",
      file = cmd_file,
      append = TRUE
    )
    
    # Store sample IDs for reference
    ll <- c(ll, paste(sample_id, "_run", run, sep = ""))
  }
}

# Output the list of processed samples (optional)
print(ll)