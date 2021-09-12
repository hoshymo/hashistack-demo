
provider "nomad" {
  address = "http://localhost:4646"
}

variable "appver" {
  default = "latest"
}

data "template_file" "job" {
  template = "${file("./example.hcl.tmpl")}"

  vars = {
    appver = "${var.appver}"
  }
}

# Register a job
resource "nomad_job" "example-job" {
  jobspec = "${data.template_file.job.rendered}"
}
