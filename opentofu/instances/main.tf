resource "google_compute_instance" "harvest_vm" {
  name         = var.name
  machine_type = var.machine_type
  zone         = var.zone

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


  metadata_startup_script = <<-EOF
    #!/bin/bash
    echo "Startup script initiated" > /var/log/startup.log

    # Step 1: Install Docker
    curl -O https://raw.githubusercontent.com/cgs-earth/script-cache/refs/heads/master/install_docker.sh
    bash install_docker.sh

    # Step 2: Install Scheduler
    apt install -y git
    sudo git clone --branch "${var.scheduler_version}" https://github.com/internetofwater/scheduler.git /opt/scheduler

    # Step 3: Set up Scheduler Environment
    cd /opt/scheduler
    cat <<ENV | sudo tee /opt/scheduler/.env > /dev/null
    # Configs
    REMOTE_GLEANER_SITEMAP=${var.sitemap_url}
    GLEANER_HEADLESS_ENDPOINT=http://headless:9222
    GLEANERIO_HEADLESS_NETWORK=headless_gleanerio
    # Docker
    GLEANERIO_GLEANER_IMAGE=internetofwater/gleaner:latest
    GLEANERIO_NABU_IMAGE=internetofwater/nabu:latest
    # Minio
    GLEANERIO_MINIO_ADDRESS=storage.googleapis.com
    GLEANERIO_MINIO_PORT=443
    GLEANERIO_MINIO_USE_SSL=true
    GLEANERIO_MINIO_BUCKET=${var.s3_bucket}
    GLEANERIO_MINIO_REGION=${var.s3_region}
    MINIO_ACCESS_KEY=${var.s3_access_key}
    MINIO_SECRET_KEY=${var.s3_secret_key}
    # GraphDB
    GLEANERIO_GRAPH_URL=http://graphdb:7200
    GLEANERIO_GRAPH_NAMESPACE=${var.data_graph}
    GLEANERIO_DATAGRAPH_ENDPOINT=${var.data_graph}
    GLEANERIO_PROVGRAPH_ENDPOINT=${var.prov_graph}
    # Dagster
    DAGSTER_POSTGRES_USER=postgres
    DAGSTER_POSTGRES_PASSWORD=postgres_password
    DAGSTER_POSTGRES_DB=postgres_db
    ## This should match the env vars for dagster postgres
    POSTGRES_USER=postgres
    POSTGRES_PASSWORD=postgres_password
    POSTGRES_DB=postgres_db
    # Integrations / Notifications
    DAGSTER_SLACK_TOKEN=xoxe.xoxp-1-Mi0yLTMwMDkzMzg0NTg0MzUtMzAxNjAzMTI3NDM4OS03Nzg5ODI3MjI5NzMxLTc3NzUzNjk1MzI4MDctNWU5ZTQ3NzdjOTYxNjI5OTEzOTJmZWEwYjJmZTMwNDE0M2M4MzhiNzdiZjE4MDU2N2VmOTJiNzc1NmNjMDYyNQ
    ENV

    # Step 4: Run Scheduler
    nohup python3 main.py prod &
    echo "Scheduler Started!" >> /var/log/startup.log

    # Step 5: Start GraphDB
    sudo docker run -d --name graphdb --network dagster_network -v /opt/graphdb/data:/opt/graphdb/data -e JAVA_XMX=4g -e JAVA_XMS=2048m -p 7200:7200 khaller/graphdb-free:latest
    echo "GraphDB Started!" >> /var/log/startup.log

    # Step 6: Install Caddy
    curl -O https://raw.githubusercontent.com/cgs-earth/script-cache/refs/heads/master/install_caddy.sh
    bash install_caddy.sh

    # Step 7: Run Caddy
    cat <<CADDYFILE | sudo tee /etc/caddy/Caddyfile > /dev/null
    ${var.url} {
            reverse_proxy :3000
    }
    CADDYFILE
    systemctl restart caddy

  EOF
}
