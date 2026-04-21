resource "google_cloud_run_v2_service" "pygeoapi" {
  name = "pygeoapi"
  location = var.region
  deletion_protection = false 

  ingress = "INGRESS_TRAFFIC_ALL"

  scaling {
    max_instance_count = 2
    min_instance_count = 1
    scaling_mode       = "AUTOMATIC"
  }

  template {

    # volumes {
    #   name = "job-store"
    #   gcs {
    #     bucket = "${google_storage_bucket.bucket.name}/job_results"
    #   }
    # }

    containers {
      image = "ghcr.io/internetofwater/pygeoapi:latest"
      ports {
        container_port = 80
      }
    #   volume_mounts {
    #     name       = "job-store"
    #     mount_path = "/job_results"
    #   }

      # ideally this would be set here; however, that would make
      # the cloud run service dependent on itself which terraform
      # does not allow; thus this needs to be set manually after deployment
      
      # env {
      #   name= "PYGEOAPI_URL"
      #   value = google_cloud_run_v2_service.pygeoapi.uri
      # }

    #   env {
    #     name = "PYGEOAPI_JOB_RESULT_DIR"
    #     value = "/job_results"
    #   }

      env {
        name = "TF_VAR_POSTGRES_HOST"
        value = "/cloudsql/${google_sql_database_instance.postgis.connection_name}"
      }

      env {
        name = "TF_VAR_POSTGRES_USER"
        value = var.POSTGRES_USER
      }

      env {
        name = "TF_VAR_POSTGRES_PASSWORD"
        value = var.database_password
      }

      env {
        name = "TF_VAR_POSTGRES_DB"
        value = var.POSTGRES_DB
      }

    #   env {
    #     name = "REDIS_HOST"
    #     value = google_redis_instance.redis.host
    #   }

      resources {
        limits = {
          cpu = "3"
          memory = "2GiB"
        }
        cpu_idle = false
      }
    }
  }

  traffic {
    # all traffic should go to the latest version
    percent = 100
    type    = "TRAFFIC_TARGET_ALLOCATION_TYPE_LATEST"
  }

}
