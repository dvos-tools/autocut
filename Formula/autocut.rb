class Autocut < Formula
  desc "A background service for running shortcuts on schedule"
  homepage "https://github.com/dvos-tools/autocut"
  version "1.0.0"
  
  # You'll need to add a URL for your release tarball
  # url "https://github.com/dvos-tools/autocut/archive/v1.0.0.tar.gz"
  # sha256 "your_sha256_here"
  
  # For now, we'll use the local directory
  head "."
  
  depends_on "node@18"
  
  def install
    # Install dependencies
    system "npm", "install"
    
    # Build the application
    system "npm", "run", "build"
    
    # Create libexec directory and copy built files
    libexec.install "dist"
    libexec.install "config.yml" if File.exist?("config.yml")
    
    # Install the plist file
    prefix.install "com.autocut.plist"
    
    # Create log directory
    (var/"log").mkpath
    
    # Make setup script executable and install it
    chmod 0755, "setup-config.sh"
    bin.install "setup-config.sh" => "autocut-setup"
  end
  
  def post_install
    # Create default config if it doesn't exist
    unless File.exist?("#{libexec}/config.yml")
      system "#{bin}/autocut-setup"
    end
  end
  
  service do
    run [opt_bin/"node", opt_libexec/"dist/app.js"]
    working_dir opt_libexec
    log_path var/"log/autocut.log"
    error_log_path var/"log/autocut.error.log"
    environment_variables NODE_ENV: "production"
  end
  
  test do
    system "#{bin}/autocut-setup", "--help"
  end
end 