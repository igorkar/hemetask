resource "aws_alb" "alb" {
  name               = "lambda-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lambda_sg.id]
  subnets            = [aws_subnet.maina.id, aws_subnet.mainb.id]

  enable_deletion_protection = false
}

resource "aws_alb_target_group" "tg" {
  name        = "lambda-tg"
  protocol    = "HTTP"
  target_type = "lambda"
  vpc_id      = aws_vpc.main.id
}

resource "aws_alb_listener" "alb_listener" {
  load_balancer_arn = aws_alb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.tg.arn
  }
}

resource "aws_alb_target_group_attachment" "lambda_attachment" {
  target_group_arn = aws_alb_target_group.tg.arn
  target_id        = aws_lambda_function.lambda_function.arn
  depends_on       = [aws_lambda_permission.with_lb]
}