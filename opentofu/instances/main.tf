resource "google_compute_instance" "harvest_vm" {
  name         = var.name
  machine_type = var.machine_type
  zone         = var.zone
  metadata     = {
    enable-osconfig = "TRUE"
  }
  tags = [ "https-server" ]

  boot_disk {
    initialize_params {
      image = "debian-cloud/${var.instance_os}"
      size  = var.disk_size
    }
  }

  network_interface {
    network = var.network_name
    access_config {
      nat_ip = var.static_ip
    }
  }

  service_account {
    email  = var.service_account_email
    scopes = ["cloud-platform"]
  }

  metadata_startup_script = <<-EOF
    #!/bin/bash
    echo "Startup script initiated" > /var/log/startup.log

    # Step 1: Install Docker
    curl -sSL https://cgs-earth.github.io/script-cache/install_docker.sh | bash

    # Step 2: Install Scheduler
    echo "Downloading Scheduler" >> /var/log/startup.log
    apt install -y git
    sudo git clone --branch "${var.scheduler_version}" https://github.com/internetofwater/scheduler.git /opt/scheduler

    # Step 3: Set up Scheduler Environment
    cd /opt/scheduler
    cat <<ENV | sudo tee /opt/scheduler/.env > /dev/null

    # Gleaner
    GLEANER_HEADLESS_ENDPOINT=${var.headless_url}
    REMOTE_GLEANER_SITEMAP=${var.sitemap_url}
    GLEANER_THREADS=10

    # Nabu
    NABU_PROFILING=false
    NABU_LOG_LEVEL=ERROR

    # Minio
    GLEANERIO_MINIO_ADDRESS=storage.googleapis.com
    GLEANERIO_MINIO_PORT=443
    GLEANERIO_MINIO_USE_SSL=true
    GLEANERIO_MINIO_BUCKET=${var.s3_bucket}
    GLEANERIO_MINIO_REGION=${var.s3_region}
    MINIO_ACCESS_KEY=${var.s3_access_key}
    MINIO_SECRET_KEY=${var.s3_secret_key}

    # GraphDB
    GLEANERIO_GRAPH_URL=${var.graph_url}
    GLEANERIO_GRAPH_NAMESPACE=${var.data_graph}
    GLEANERIO_DATAGRAPH_ENDPOINT=${var.data_graph}
    GLEANERIO_PROVGRAPH_ENDPOINT=${var.prov_graph}

    # Database
    DAGSTER_POSTGRES_HOST=${var.database_host}
    DAGSTER_POSTGRES_USER=${var.database_user}
    DAGSTER_POSTGRES_PASSWORD=${var.database_password}
    DAGSTER_POSTGRES_DB=${var.database_name}

    # Integrations / Notifications
    DAGSTER_SLACK_TOKEN=${var.dagster_slack_token}
    LAKEFS_ENDPOINT_URL=${var.lakefs_endpoint}
    LAKEFS_ACCESS_KEY_ID=${var.lakefs_access_key}
    LAKEFS_SECRET_ACCESS_KEY=${var.lakefs_secret_key}
    ZENODO_ACCESS_TOKEN=${var.zenodo_access_token}
    ZENODO_SANDBOX_ACCESS_TOKEN=unset

    ENV

    echo "Pulling Scheduler images" >> /var/log/startup.log
    python3 main.py pull --profiles production

    # Step 4: Run Scheduler
    nohup python3 main.py prod --build &
    echo "Scheduler Started!" >> /var/log/startup.log

    if [ ${var.enable_public_url} != "false" ]; then
      # Step 5: Install Caddy
      curl -sSL https://cgs-earth.github.io/script-cache/install_caddy.sh | bash

      # Step 6: Run Caddy
      cat <<CADDYFILE | sudo tee /etc/caddy/Caddyfile > /dev/null
      ${var.url} {
              reverse_proxy :3000
      }
      CADDYFILE
      systemctl restart caddy
    fi

  EOF
}
