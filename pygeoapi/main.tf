resource "google_cloud_run_v2_service" "pygeoapi" {
  name                = "pygeoapi"
  location            = var.region
  deletion_protection = false

  ingress = "INGRESS_TRAFFIC_ALL"

  scaling {
    max_instance_count = 2
    min_instance_count = 1
    scaling_mode       = "AUTOMATIC"
  }




  template {
    volumes {
      name = "config-volume"
      gcs {
        bucket = var.config_bucket
      }
    }
    # dont think we need jobs for now so this is commented out
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
        name  = "PYGEOAPI_CONFIG"
        value = "/config/pygeoapi/pygeoapi.config.yml"
      }
      env {
        name  = "POSTGRES_HOST"
        value = "/cloudsql/${google_sql_database_instance.postgis.connection_name}"
      }

      env {
        name  = "POSTGRES_USER"
        value = var.POSTGRES_USER
      }

      env {
        name  = "POSTGRES_PASSWORD"
        value = var.POSTGRES_PASSWORD
      }

      env {
        name  = "POSTGRES_DB"
        value = var.POSTGRES_DB
      }

      #   env {
      #     name = "REDIS_HOST"
      #     value = google_redis_instance.redis.host
      #   }

      resources {
        limits = {
          cpu    = "3"
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


resource "google_storage_bucket_object" "pygeoapi_config" {
  name   = "pygeoapi/pygeoapi.config.yml"
  bucket = var.config_bucket
  source = "${path.module}/pygeoapi.config.yml"
}


resource "google_storage_bucket_iam_member" "pygeoapi_access" {
  bucket = var.config_bucket
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:${var.service_account_email}"
}