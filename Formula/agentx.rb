# typed: false
# frozen_string_literal: true

# Prebuilt AgentX macOS binaries. Version and checksums are stamped by the
# release pipeline after the artifacts are published to app.agentxhq.io —
# do not hand-edit them.
class Agentx < Formula
  desc "AgentX multi-agent host daemon"
  homepage "https://www.agentxhq.com/"
  version "0.106.0"
  license "Proprietary"

  livecheck do
    skip "Version is stamped at release time from the AgentX release feed"
  end

  on_macos do
    on_arm do
      url "https://app.agentxhq.io/releases/agentx-0.106.0-darwin-arm64.tar.gz"
      sha256 "32eb71bcc99fc7320576a279bc08424e0332cc66eeff353fc91bc09b3670144b"
    end
    on_intel do
      url "https://app.agentxhq.io/releases/agentx-0.106.0-darwin-amd64.tar.gz"
      sha256 "0a922e77c9b4380cbd0c6341bfb0e8610e178756d8790b928b4b4602ed8b4c78"
    end
  end

  def install
    bin.install "agentx-daemon"
    bin.install "agentx"
    bin.install_symlink "agentx" => "agentx-browser"
  end

  def caveats
    <<~EOS
      AgentX state lives in ~/.agentx/ (config, sqlite, logs).

      Start it:
        agentx-daemon background
        agentx-daemon status
        open http://127.0.0.1:3333/console

      Or run it at login:
        brew services start agentx

      These builds are not signed or notarized. Homebrew installs them without
      a Gatekeeper prompt; a manual download would need:
        xattr -dr com.apple.quarantine $(brew --prefix)/bin/agentx-daemon
    EOS
  end

  service do
    run [opt_bin/"agentx-daemon", "serve"]
    keep_alive true
    environment_variables PATH: std_service_path_env
    log_path var/"log/agentx.log"
    error_log_path var/"log/agentx.err.log"
  end

  test do
    assert_match(/\d/, shell_output("#{bin}/agentx-daemon version"))
  end
end
