resource "google_cloudbuild_trigger" "ci" {
  name = "${var.team}-ci"
  trigger_template {
    repo_name = var.source_repository.name
    branch_name = "tf-v2"
  }
  included_files = ["src/${var.team}/**", "src/components/**"]
  filename = var.pipeline_definition_filename
  substitutions = {
      _TEAM = "${var.team}"
      _CACHE_URI = "gs://${google_storage_bucket.build_cache.name}/${google_storage_bucket_object.cache.name}"
      _CONTAINER_REGISTRY = "${var.container_registry.location}-docker.pkg.dev/${var.container_registry.project}/${var.container_registry.repository_id}"
      _SOURCE_STAGING_BUCKET = "gs://${google_storage_bucket.release_source_staging.name}/"
  }
  service_account = google_service_account.cloud_build.id
}