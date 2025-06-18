# IAM Role for ECS Task Execution
resource "aws_iam_role" "ecs_task_exec" {
  name = "ecsTaskExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Attach ECS Task Execution Role Policy (pull images, write logs)
resource "aws_iam_role_policy_attachment" "ecs_task_exec_attach" {
  role       = aws_iam_role.ecs_task_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# Attach Read-Only SSM (Secrets Manager / Parameter Store)
resource "aws_iam_role_policy_attachment" "ssm_access" {
  role       = aws_iam_role.ecs_task_exec.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess"
}

# Attach S3 Read-Only Access
resource "aws_iam_role_policy_attachment" "s3_read_access" {
  role       = aws_iam_role.ecs_task_exec.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}
