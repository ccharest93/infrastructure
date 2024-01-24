output "gpu-ami"{
    value = nonsensitive(data.aws_ssm_parameter.gpu-ami.value)
} 
output "node-ami"{
    value = nonsensitive(data.aws_ssm_parameter.node-ami.value)
}