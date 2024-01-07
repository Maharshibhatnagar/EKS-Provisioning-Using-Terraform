resource "aws_instance" "web" {
  ami           = "ami-03f4878755434977f"
  instance_type = "t2.large"
  key_name   = "letsgo" #Your key name
  vpc_security_group_ids = [ aws_security_group.jenkins-sg.id]
  user_data = templatefile("./install.sh", {})

  tags = {
    Name = "jenkins-sonarqube"
  }
  
  root_block_device {
    volume_size = 15
  }
}


resource "aws_security_group" "jenkins-sg" {
  name        = "jenkins-sg"
  description = "Allow TLS inbound traffic"

  ingress = [
    for port in [22, 80, 443, 8080, 9000] : {
        description          = "inbound rules"
        from_port            = port
        to_port              = port
        protocol             = "tcp"
        cidr_blocks          = ["0.0.0.0/0"]
        ipv6_cidr_blocks     = []
        prefix_list_ids      = []
        security_groups      = []
        self                 = false
    }
  ]

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "jenkins-sg"
  }
}