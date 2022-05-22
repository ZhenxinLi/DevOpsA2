resource "local_file" "env_file" {
    content = <<-DOC
    DB=${aws_instance.db.public_ip}
    WEB=${aws_instance.web.public_ip}
    DOC
    filename = "../ansible/.env"
}