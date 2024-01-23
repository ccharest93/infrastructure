resource "aws_efs_file_system" "this" {
    creation_token = "${var.env}-efs-fs"
    availability_zone_name = var.availability_zone
} 

resource "aws_efs_mount_target" "this" {
  file_system_id = aws_efs_file_system.this.id
  subnet_id      = var.subnet_id
  security_groups = [aws_security_group.this.id]
}
