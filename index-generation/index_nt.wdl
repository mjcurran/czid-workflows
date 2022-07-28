version development

workflow index_nt {
    input {
        String index_name
        String docker_image_id
        File nt = "/data/czid/czid-workflows/20220721_142502_index_generation/call-DownloadNT/work/blast/db/FASTA/nt"
        
    }

    

    

    call GenerateNTDB {
        input:
        nt = nt,
        docker_image_id = docker_image_id
    }


    output {
        
        File nt_loc_db = GenerateNTDB.nt_loc_db
        File nt_info_db = GenerateNTDB.nt_info_db
        
    }
}




task GenerateNTDB {
    input {
        File nt
        String docker_image_id
    }

    command <<<
        python3 /usr/local/bin/generate_loc_db.py ~{nt} nt_loc.db nt_info.db
    >>>

    output {
        File nt_loc_db = "nt_loc.db"
        File nt_info_db = "nt_info.db"
    }

    runtime {
        docker: docker_image_id
    }
}










