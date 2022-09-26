# lsf-SLM-tags
LSF products usage tracking utility

## Introduction

Scripts for tracking product usage.
* lsf_log2slm.sh - This script logs usage info for LSF Standard in a Schema format.
* lsf_log2txt.sh - This script logs usage info for LSF Standard in a text format.
* lsf_suitelog2txt.sh - This script logs usage info for the LSF Suite.

Other files.
* vul.xlsx - This Excel spreadsheet will analyze the text data you import.

## Installation and configuration

* Download scripts from the repository

* Update the script execution permission

    ```
    $ chmod u+x  lsf_log2txt.sh
    $ chmod u+x  lsf_log2slm.sh
	$ chmod u+x  lsf_suitelog2txt.sh
    ```
* Update log_location & lsf_top values as per your settings on lsf_log2txt.sh and lsf_log2slm.sh 
* Execute script using the below commands 

    ```
    $ ./lsf_log2txt.sh
    $ ./lsf_log2slm.sh
    $ ./lsf_suitelog2txt.sh
    ```
