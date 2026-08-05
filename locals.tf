# Enables all services needed for a project
locals {
  gcp_services = [
    "compute.googleapis.com",
    "dns.googleapis.com",
    "storage-api.googleapis.com",
    "container.googleapis.com",
    "file.googleapis.com",
    "artifactregistry.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "containeranalysis.googleapis.com",
    "run.googleapis.com",
  ]
}