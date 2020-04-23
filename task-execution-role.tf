resource "aws_iam_role" "playground-task-execution-role" {
  name               = "ecs-task-execution-role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.task-execution-policy.json
}

data "aws_iam_policy_document" "task-execution-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "task-execution-role-attachment" {
  role       = aws_iam_role.playground-task-execution-role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}