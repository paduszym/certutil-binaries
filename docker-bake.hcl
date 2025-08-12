VERSION = "NSS-3.114_NSPR-4.37"
PLATFORM = [
  { os = "linux", arch = "x64" },
  { os = "linux", arch = "aarch64" },
  { os = "macos", arch = "x64" },
  { os = "macos", arch = "aarch64" },
  { os = "windows", arch = "x64" }
]

target "default" {
  name   = "certutil-${platform.os}-${platform.arch}"
  matrix = {
    platform = PLATFORM
  }
  args = {
    VERSION = VERSION
    OS      = platform.os
    ARCH    = platform.arch
  }
  output = [{ type = "local", dest = "dist" }]
}
