version development

workflow index_accessions {
    input {
        String index_name
        String ncbi_server = "https://ftp.ncbi.nih.gov"
        String? s3_dir
        File? previous_lineages
        String docker_image_id
        File nt = "databases/nt"
        File nr = "databases/nr"
        Directory accession2taxid = "databases/accession2taxid"
        File taxdump = "databases/taxdump.tar"
    }

    

    call GenerateIndexAccessions {
        input:
        nr = nr,
        nt = nt,
        accession2taxid = accession2taxid,
        docker_image_id = docker_image_id
    }


    output {
        File accession2taxid_db = GenerateIndexAccessions.accession2taxid_db
        
    }
}


task GenerateIndexAccessions {
    input {
        File nr
        File nt
        Int parallelism = 8
        Directory accession2taxid
        String docker_image_id
    }

    command <<<
        set -euxo pipefail

        # Build index
        python3 /usr/local/bin/generate_accession2taxid.py \
            ~{accession2taxid}/nucl_wgs.accession2taxid \
            ~{accession2taxid}/nucl_gb.accession2taxid \
            ~{accession2taxid}/pdb.accession2taxid \
            ~{accession2taxid}/prot.accession2taxid.FULL \
            --parallelism ~{parallelism} \
            --nt_file ~{nt} \
            --nr_file ~{nr} \
            --accession2taxid_db accession2taxid.db \
    >>>

    output {
        File accession2taxid_db = "accession2taxid.db"
    }

    runtime {
        docker: docker_image_id
    }
}










