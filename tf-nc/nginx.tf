
data "template_file" "nginx-template" {
  template = "${file("./nginx.hcl.tmpl")}"

  vars = {
    appver = "${var.appver}"
  }
}

# Register a job
resource "nomad_job" "nginx-job" {
  jobspec = "${data.template_file.nginx-template.rendered}"
}
