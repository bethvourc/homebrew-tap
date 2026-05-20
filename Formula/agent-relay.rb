# Homebrew formula template — rendered by packaging/homebrew/render.py.
#
# Substitutions (Python `Template`-style $NAME):
#   $VERSION
#   $URL_MACOS_ARM64  $SHA_MACOS_ARM64
#   $URL_LINUX_X64    $SHA_LINUX_X64
#   $URL_LINUX_ARM64  $SHA_LINUX_ARM64
#
# Intel macOS is intentionally absent — GitHub deprecated macos-13 in 2026,
# so we no longer build a darwin-x64 binary. Intel-Mac users install via
# the curl one-liner at agent-relay.dev (it falls back to uv).
class AgentRelay < Formula
  desc "Local-first CLI for handing AI coding sessions between agents without losing context"
  homepage "https://agent-relay.dev"
  version "0.6.3"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/bethvourc/agent--relay/releases/download/v0.6.3/relay-darwin-arm64"
      sha256 "4b25e733152e27824f6041352256d000c8b0e7161fb71e4d26298e792b8d85d2"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/bethvourc/agent--relay/releases/download/v0.6.3/relay-linux-arm64"
      sha256 "d7bc7f43ae8be700d03db2e950935d1ed24664e3a08ed773622198e85555ac42"
    end
    on_intel do
      url "https://github.com/bethvourc/agent--relay/releases/download/v0.6.3/relay-linux-x64"
      sha256 "494841de55c290fed3d03148ae235ac07ef4d853dfefbab9ea9b686a28a72c77"
    end
  end

  def install
    # PyInstaller binaries arrive as a single executable file. We rename to
    # `relay` so users can run either `agent-relay` (the homebrew formula
    # name) or `relay` (the canonical short command).
    Dir.glob("relay-*").each do |downloaded|
      bin.install downloaded => "relay"
    end
    # Alias so existing PyPI-style invocations keep working.
    bin.install_symlink bin/"relay" => "agent-relay"
  end

  test do
    assert_match "agent-relay", shell_output("#{bin}/relay --help")
  end
end
