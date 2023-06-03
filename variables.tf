variable "project_id" {
  type    = string
  default = "moringa-387909"
}

variable "instances" {
  type = list(string)
  default = [
    "yolo-server",
  ]
}