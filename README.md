# lsf-SLM-tags
Software License Metric (SLM) usage tracking utility for IBM Spectrum LSF products

## Introduction

Scripts for tracking product usage.
* lsf_log2slm.sh - This script logs usage information for LSF Standard Edition in a schema format.
* lsf_log2txt.sh - This script logs usage information for LSF Standard Edition in a text format.
* lsf_suitelog2txt.sh - This script logs usage information for all the IBM Spectrum LSF Suite products.

Other files.
* vul.xlsx - This Microsoft Excel spreadsheet will analyze the text data you import.

## Installation and configuration

1. Download scripts from the repository

1. Update the script execution permission

    ```
    $ chmod u+x  lsf_log2txt.sh
    $ chmod u+x  lsf_log2slm.sh
    $ chmod u+x  lsf_suitelog2txt.sh
    ```
1. Update the log_location value as per your settings on lsf_log2txt.sh and lsf_log2slm.sh 

1. Execute the script for the product you are using, using the commands below.

    ```
    $ ./lsf_log2txt.sh
    $ ./lsf_log2slm.sh
    $ ./lsf_suitelog2txt.sh
    ```
