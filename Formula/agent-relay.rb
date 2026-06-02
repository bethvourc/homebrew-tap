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
  version "0.7.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/bethvourc/agent--relay/releases/download/v0.7.0/relay-darwin-arm64"
      sha256 "33e19e2c0ba94a839cab8cd16c2563b9a53b620f970e8321b7125872515c31b5"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/bethvourc/agent--relay/releases/download/v0.7.0/relay-linux-arm64"
      sha256 "95170e3e24f1d4943b9c7f52c5ddacf1ec5b1013e0fc0761cc239206a1f76b1f"
    end
    on_intel do
      url "https://github.com/bethvourc/agent--relay/releases/download/v0.7.0/relay-linux-x64"
      sha256 "924dc35fc51f7d275407e6ded5a5239d371297c4e24a4d50ed3253038d1a91d1"
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

  def caveats
    <<~EOS
      To wire local hooks, the daemon, and automatic rate-limit handoffs, run:
        relay install

      Then start the Relay REPL:
        relay

      If Relay cannot infer your preferred fallback chain, configure it with:
        relay install --handoff-order claude codex
    EOS
  end

  test do
    assert_match "agent-relay", shell_output("#{bin}/relay --help")
  end
end
