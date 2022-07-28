version development

workflow index_generation {
    input {
        String index_name
        String docker_image_id
        File nt = "/data/czid/czid-workflows/20220721_142502_index_generation/call-DownloadNT/work/blast/db/FASTA/nt"
        
        
    }

    

   

    call GenerateNRDB {
        input:
        nr = nr,
        docker_image_id = docker_image_id
    }

 
    
    


    


    output {
        
        File nr_loc_db = GenerateNRDB.nr_loc_db
        
    }
}






task GenerateNRDB {
    input {
        File nr
        String docker_image_id
    }

    command <<<
        python3 /usr/local/bin/generate_loc_db.py ~{nr} nr_loc.db nr_info.db
    >>>

    output {
        File nr_loc_db = "nr_loc.db"
    }

    runtime {
        docker: docker_image_id
    }
}





