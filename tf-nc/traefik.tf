
data "template_file" "traefik-template" {
  template = "${file("./traefik.hcl.tmpl")}"

  vars = {
    appver = "${var.appver}"
  }
}

# Register a job
resource "nomad_job" "traefik-job" {
  jobspec = "${data.template_file.traefik-template.rendered}"
}
