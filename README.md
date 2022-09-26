# lsf-SLM-tags

## Introduction

Scripts for tracking product usage. We are using 2 scripts for usage tracking
* lsf_log2slm.sh - details in Schema format
* lsf_log2txt.sh - details in text format

## Installation and configuration

* Download scripts from the repository

* Update the script execution permission

    ```
    $ chmod u+x  lsf_log2txt.sh
    $ chmod u+x  lsf_log2slm.sh
    ```
* Update log_location & lsf_top values as per your settings on lsf_log2txt.sh and lsf_log2slm.sh 
* Execute script using the below commands 

    ```
    $ ./lsf_log2txt.sh
    $ ./lsf_log2slm.sh
    ```
