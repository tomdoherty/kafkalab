variable "hosts" {
  type = set(string)
  default = [
    "controller-0",
    "worker-0",
    "worker-1",
    "worker-2",
  ]
}
