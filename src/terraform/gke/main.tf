resource "google_container_cluster" "cicd_cluster" {
  name        = "${var.app_name}-cluster"
  project     = var.project
  description = "CI/CD GKE Cluster"
  location    = var.region

  remove_default_node_pool = true
  initial_node_count       = var.initial_node_count

  master_auth {
    username = ""
    password = ""

    client_certificate_config {
      issue_client_certificate = false
    }
  }
}

resource "google_container_node_pool" "cicd_node" {
  name       = "${var.app_name}-node-pool"
  project    = var.project
  location   = google_container_cluster.cicd_cluster.location
  cluster    = google_container_cluster.cicd_cluster.name
  node_count = 1

  node_config {
    preemptible  = true
    machine_type = var.machine_type

    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    labels = {
      name = "worker"
    }

    tags = ["name", "worker"]
  }
}

