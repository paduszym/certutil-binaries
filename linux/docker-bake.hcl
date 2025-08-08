target "default" {
  name = "certutil-${arch}"
  matrix = {
    arch = ["amd64", "aarch64"]
  }
  args = {
    ARCH = arch
  }
  output = [
    { type = "local", dest = "dist/${arch}" }
  ]
}
