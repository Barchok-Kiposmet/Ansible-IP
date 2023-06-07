variable "project_id" {
  type    = string
  default = "moringa-387909"
}

variable "instances" {
  type = list(string)
  default = [
    "yolo-client",
    "yolo-backend",
  ]
}

variable "ansible_id" {
  type = list(string)
  default = [ "318909862340-compute@developer.gserviceaccount.com" ]
  
}